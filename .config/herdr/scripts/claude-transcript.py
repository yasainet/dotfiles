#!/usr/bin/env python3
"""herdr pane で動く Claude Code の transcript を読める形に整形して stdout に出す。

herdr の scrollback ではなく Claude Code が書く jsonl を読むので、
tui の設定やリサイズによる表示崩れの影響を受けない。
"""

import argparse
import json
import pathlib
import subprocess
import sys


def resolve_transcript(pane_id):
    raw = subprocess.run(
        ["herdr", "pane", "get", pane_id], capture_output=True, text=True, check=True
    ).stdout
    pane = json.loads(raw)["result"]["pane"]
    session = (pane.get("agent_session") or {}).get("value")
    if not session:
        sys.exit(f"pane {pane_id} に agent session がありません")

    # projects 配下のディレクトリ名は cwd の単純置換ではないため、
    # session id が一意である性質を使って glob で引く
    found = sorted((pathlib.Path.home() / ".claude" / "projects").glob(f"*/{session}.jsonl"))
    if not found:
        sys.exit(f"transcript が見つかりません: session={session}")
    return found[-1]


def blocks(content):
    if isinstance(content, str):
        yield "text", content
        return
    for b in content or []:
        kind = b.get("type")
        if kind == "text":
            yield "text", b.get("text", "")
        elif kind == "tool_use":
            yield "tool", b.get("name", "?")


def read_turns(path):
    """(role, [(kind, value)]) の並びに落とす。読む対象のない turn は捨てる。"""
    turns = []
    for raw in path.read_text().splitlines():
        if not raw.strip():
            continue
        try:
            row = json.loads(raw)
        except json.JSONDecodeError:
            continue
        if row.get("type") not in ("user", "assistant"):
            continue
        msg = row.get("message") or {}
        body = [(k, v) for k, v in blocks(msg.get("content")) if v.strip()]
        if body:
            turns.append((msg.get("role"), body))
    return turns


def render_full(turns):
    lines, marks = [], []
    for role, body in turns:
        if role == "user":
            lines += ["", "=" * 78]
            for _, v in body:
                lines += [f"> {l}" for l in v.strip().splitlines()]
            lines.append("=" * 78)
        else:
            lines.append("")
            for kind, v in body:
                if kind == "tool":
                    lines.append(f"  [{v}]")
                else:
                    marks.append(len(lines))
                    lines += v.strip().splitlines()
    return lines, (marks[-1] if marks else len(lines))


def render_last(turns):
    for role, body in reversed(turns):
        if role != "assistant":
            continue
        text = [v for k, v in body if k == "text"]
        if text:
            return "\n\n".join(t.strip() for t in text).splitlines()
    return []


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--pane", default=None, help="対象 pane id (既定: $HERDR_PANE_ID)")
    ap.add_argument("--last", action="store_true", help="直近の応答だけを出す")
    args = ap.parse_args()

    import os

    pane_id = args.pane or os.environ.get("HERDR_PANE_ID")
    if not pane_id:
        pane_id = json.loads(
            subprocess.run(
                ["herdr", "pane", "current"], capture_output=True, text=True, check=True
            ).stdout
        )["result"]["pane"]["pane_id"]

    turns = read_turns(resolve_transcript(pane_id))

    if args.last:
        out = render_last(turns)
        if not out:
            sys.exit("直近の応答が見つかりません")
        print("\n".join(out))
        return

    lines, mark = render_full(turns)
    print("\n".join(lines))
    # 呼び出し側がカーソルを最新応答へ置けるよう、行番号は stderr に流す
    print(mark, file=sys.stderr)


if __name__ == "__main__":
    main()

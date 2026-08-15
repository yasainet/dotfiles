---
name: simplepowers-01-explore
description: [Explore]
---

# Explore

Start by declaring `[Explore]`.

## Purpose

`user` の質問や相談・目的に沿って、コードや仕様・原因を調査して Goal を決定する。

## Scope

In Scope:

- `user` の質問や相談・目的に沿った調査をする
- `user` の指示があるまで協議をして、Goal の決定をする
- `user` の指示するスコープに従え。スコープを広げるな

Out of Scope:

- `Explore` の Phase では、あらゆるファイルに対する編集を禁止する

## Responsibilities

| When                     | Tools                                       |
| ------------------------ | ------------------------------------------- |
| 内部の簡易的な検索       | `Glob`, `Grep`, `Read`, `LSP`, `Bash`, etc. |
| 内部の探索範囲が広い     | `@Explore`                                  |
| 外部の探索範囲まで及ぶ   | `@general-purpose`, `deep-research`         |
| 最新の library を引く    | `context7`, `WebSearch`                     |
| Claude Code の仕様を引く | `claude-code-guide`                         |

## Procedure

1. LLM の知識、推測に頼るな。`user` の質問や相談・目的に沿って、該当する Tool を使え
2. 内部の調査と外部の調査をして、回答せよ
3. `user` と協議をして Goal を決定せよ。Goal は一つに絞り、4 行以内で示せ
4. `user` が Goal に合意した場合にのみ、`Plan` へ移行せよ

## References

N/A

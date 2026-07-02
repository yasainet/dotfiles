#!/usr/bin/env node

import fs from "node:fs";
import os from "node:os";
import path from "node:path";

const rulesDir = path.join(os.homedir(), ".claude", "rules");

/** frontmatter の `paths:` リスト (glob) を抜き出す */
const parsePaths = (raw) => {
  const fm = raw.match(/^---\n([\s\S]*?)\n---/);
  if (!fm) return [];
  const out = [];
  let inPaths = false;
  for (const line of fm[1].split("\n")) {
    if (/^paths:\s*$/.test(line)) {
      inPaths = true;
      continue;
    }
    if (!inPaths) continue;
    const item = line.match(/^\s*-\s*(.+?)\s*$/);
    if (item) {
      out.push(item[1].replace(/^["']|["']$/g, ""));
    } else if (/^\S/.test(line)) {
      inPaths = false; // 次の top-level key で paths リスト終了
    }
  }
  return out;
};

/** rules ディレクトリを走査し { globs, body } を集める */
const loadRules = () => {
  let files;
  try {
    files = fs.readdirSync(rulesDir, { recursive: true });
  } catch {
    return [];
  }
  return files
    .filter((f) => f.endsWith(".md"))
    .sort() // readdir 順に依存しない決定的な注入順にする
    .map((f) => {
      const raw = fs.readFileSync(path.join(rulesDir, f), "utf8");
      return {
        globs: parsePaths(raw),
        body: raw.replace(/^---\n[\s\S]*?\n---\n?/, "").trim(),
      };
    });
};

let input = "";
try {
  input = fs.readFileSync(0, "utf8");
} catch {
  process.exit(0);
}

let filePath = "";
try {
  filePath = JSON.parse(input)?.tool_input?.file_path ?? "";
} catch {
  process.exit(0);
}
if (!filePath) process.exit(0);

// Write-create のみ対象。既存ファイルへの Write/Edit は別経路 (Read-trigger) で
// rule が届くため、ここで再注入すると過剰になる。未存在のときだけ進む。
if (fs.existsSync(filePath)) process.exit(0);

const matches = (globs) =>
  globs.some((g) => {
    try {
      return path.matchesGlob(filePath, g);
    } catch {
      return false;
    }
  });

const bodies = [];
for (const rule of loadRules()) {
  if (rule.body && matches(rule.globs)) bodies.push(rule.body);
}
if (bodies.length === 0) process.exit(0);

process.stdout.write(
  JSON.stringify({
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      additionalContext: bodies.join("\n\n---\n\n"),
    },
  }),
);

#!/usr/bin/env node
// PreToolUse(Write) hook — Write-create だけを対象にする。
//
// path-rules は Read でしか発火しない。Edit は事前 Read が必須なので Read-trigger で
// rule が既に発火済み、上書き Write も通常は事前 Read 済み。残る穴は「新規ファイルを
// Read を踏まず Write 生成する」グリーンフィールド経路だけ。よって対象 path にマッチし、
// かつ未存在のファイルへの Write のときだけ rule 本文を additionalContext で注入する。
//
// 注意: glob の再実装は native engine と食い違うため避ける。
// path 判定は単純な substring に留め、rule 本文だけ rule ファイルから動的に読む。

const fs = require("fs");
const os = require("os");
const path = require("path");

// { 対象 path の substring 判定, 注入する rule ファイル }
const RULES = [
  { match: (p) => p.includes("/src/lib/"), file: "src/lib.md" },
  { match: (p) => p.includes("/queries/"), file: "src/features/queries.md" },
  { match: (p) => p.includes("/services/"), file: "src/features/services.md" },
];

const rulesDir = path.join(os.homedir(), ".claude", "rules");

/** frontmatter を除いた rule 本文を返す */
const readRuleBody = (file) => {
  const raw = fs.readFileSync(path.join(rulesDir, file), "utf8");
  return raw.replace(/^---\n[\s\S]*?\n---\n?/, "").trim();
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

const bodies = [];
for (const rule of RULES) {
  if (!rule.match(filePath)) continue;
  try {
    const body = readRuleBody(rule.file);
    if (body) bodies.push(body);
  } catch {
    // rule ファイルが無ければ黙ってスキップ
  }
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

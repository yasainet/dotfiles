#!/usr/bin/env node

import fs from "node:fs";
import os from "node:os";
import path from "node:path";

const skillsDir = path.join(os.homedir(), ".claude", "skills");

const SKILLS = [
  { name: "issue", prompt: /issue/i, command: /^\s*gh\s+issue\b/ },
  { name: "commit", prompt: /commit/i, command: /^\s*git\s+commit\b/ },
  { name: "bump", prompt: /bump/i, command: /^\s*git\s+tag\b/ },
];

let input = "";
try {
  input = fs.readFileSync(0, "utf8");
} catch {
  process.exit(0);
}

let payload;
try {
  payload = JSON.parse(input);
} catch {
  process.exit(0);
}

const event = payload.hook_event_name;

const matches = SKILLS.filter((s) => {
  if (event === "UserPromptSubmit") return s.prompt.test(payload.prompt ?? "");
  if (event === "PreToolUse")
    return s.command.test(payload.tool_input?.command ?? "");
  return false;
});

if (matches.length === 0) process.exit(0);

const bodies = [];
for (const s of matches) {
  let raw;
  try {
    raw = fs.readFileSync(path.join(skillsDir, s.name, "SKILL.md"), "utf8");
  } catch {
    continue;
  }
  const body = raw.replace(/^---\n[\s\S]*?\n---\n?/, "").trim();
  if (body) bodies.push(body);
}

if (bodies.length === 0) process.exit(0);

process.stdout.write(
  JSON.stringify({
    hookSpecificOutput: {
      hookEventName: event,
      additionalContext: bodies.join("\n\n---\n\n"),
    },
  }),
);

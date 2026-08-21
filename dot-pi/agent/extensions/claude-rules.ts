/**
 * Claude Rules Extension
 *
 * Based on pi's examples/extensions/claude-rules.ts: lists the global
 * ~/.claude/rules/ markdown files in the system prompt so the agent can
 * read the relevant rule files on demand.
 */
import { readdirSync, statSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const RULES_DIR = join(homedir(), ".claude/rules");

function findMarkdownFiles(dir: string, base = ""): string[] {
  let names: string[];
  try {
    names = readdirSync(dir);
  } catch {
    return [];
  }
  const results: string[] = [];
  for (const name of names) {
    // statSync follows symlinks (Dirent flags would skip symlinked entries)
    let stat;
    try {
      stat = statSync(join(dir, name));
    } catch {
      continue;
    }
    const relative = base ? `${base}/${name}` : name;
    if (stat.isDirectory()) {
      results.push(...findMarkdownFiles(join(dir, name), relative));
    } else if (stat.isFile() && name.endsWith(".md")) {
      results.push(relative);
    }
  }
  return results;
}

export default function (pi: ExtensionAPI) {
  let files: string[] = [];

  pi.on("session_start", () => {
    files = findMarkdownFiles(RULES_DIR);
  });

  pi.on("before_agent_start", (event) => {
    if (files.length === 0) return;
    const list = files.map((f) => `- ${RULES_DIR}/${f}`).join("\n");
    return {
      systemPrompt: `${event.systemPrompt}

## Global Rules

The following global rules are available in ~/.claude/rules/:

${list}

When working on tasks related to these rules, use the read tool to load the relevant rule files for guidance.`,
    };
  });
}

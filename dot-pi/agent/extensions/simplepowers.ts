/**
 * Simplepowers Bootstrap Extension
 *
 * Mirrors Claude Code's SessionStart hook (dot-claude/hooks/simplepowers.sh):
 * injects the simplepowers-00-bootstrap SKILL.md body into the system prompt
 * so the phase workflow is loaded at startup and survives compaction.
 */
import { existsSync, readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const BOOTSTRAP = join(homedir(), ".claude/skills/simplepowers-00-bootstrap/SKILL.md");

function loadBody(): string | undefined {
  if (!existsSync(BOOTSTRAP)) return;
  const lines = readFileSync(BOOTSTRAP, "utf8").split("\n");
  // Strip frontmatter (same logic as simplepowers.sh awk)
  let end = -1;
  if (lines[0] === "---") {
    for (let i = 1; i < lines.length; i++) {
      if (lines[i] === "---") {
        end = i;
        break;
      }
    }
  }
  const body = lines.slice(end + 1).join("\n").trim();
  return body || undefined;
}

export default function (pi: ExtensionAPI) {
  pi.on("before_agent_start", (event) => {
    const body = loadBody();
    if (!body) return;
    return {
      systemPrompt: `${event.systemPrompt}\n\n<EXTREMELY_IMPORTANT>\n${body}\n</EXTREMELY_IMPORTANT>`,
    };
  });
}

/**
 * Claude Rules Extension
 *
 * Based on pi's examples/extensions/claude-rules.ts: lists the global
 * ~/.claude/rules/ markdown files in the system prompt so the agent can
 * read the relevant rule files on demand.
 *
 * Each rule file self-declares its applicable paths via `paths:` globs in
 * YAML frontmatter. The injected section renders a glob -> rule file
 * mapping so the agent knows which rule to read before touching matching
 * files.
 */
import { readdirSync, readFileSync, statSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const RULES_DIR = join(homedir(), ".claude/rules");

export interface RuleFile {
  rel: string;
  paths: string[];
}

/**
 * Extract the `paths:` list from YAML frontmatter (the first `--- ... ---`
 * block). Returns [] when there is no closed frontmatter or no `paths:` key.
 * Deliberately dependency-free: the frontmatter shape is simple and owned
 * by the rule files themselves.
 */
export function parseFrontmatterPaths(content: string): string[] {
  const lines = content.split("\n");
  if (lines[0]?.trim() !== "---") return [];

  const paths: string[] = [];
  let inPaths = false;
  for (let i = 1; i < lines.length; i++) {
    const line = lines[i];
    if (line.trim() === "---") return paths; // closed frontmatter
    const key = line.match(/^([A-Za-z_][\w-]*):/);
    if (key) {
      inPaths = key[1] === "paths";
      continue;
    }
    if (!inPaths) continue;
    const item = line.match(/^\s+-\s+(.*)$/);
    if (item) paths.push(item[1].replace(/^["']|["']$/g, ""));
  }
  return []; // frontmatter never closed
}

/**
 * Build the "Global Rules" system prompt section as a glob -> rule file
 * mapping. Rules without declared paths are listed as general guidance.
 */
export function buildRulesSection(rules: RuleFile[], rulesDir: string): string {
  const list = rules
    .flatMap((r) =>
      r.paths.length > 0
        ? r.paths.map((g) => `- \`${g}\` → \`${join(rulesDir, r.rel)}\``)
        : [`- (general) \`${join(rulesDir, r.rel)}\``],
    )
    .join("\n");
  return `## Global Rules

Rules under ${rulesDir} self-declare their applicable paths in frontmatter.
Before editing or creating files matching a glob below, read the corresponding rule file:

${list}

Globs prefixed with \`!\` are advisory notes for humans, not enforced exclusions.`;
}

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
  let rules: RuleFile[] = [];

  pi.on("session_start", () => {
    rules = findMarkdownFiles(RULES_DIR).map((rel) => {
      let paths: string[] = [];
      try {
        paths = parseFrontmatterPaths(readFileSync(join(RULES_DIR, rel), "utf8"));
      } catch {
        // unreadable file: keep it listed as general guidance
      }
      return { rel, paths };
    });
  });

  pi.on("before_agent_start", (event) => {
    if (rules.length === 0) return;
    return {
      systemPrompt: `${event.systemPrompt}

${buildRulesSection(rules, RULES_DIR)}`,
    };
  });
}

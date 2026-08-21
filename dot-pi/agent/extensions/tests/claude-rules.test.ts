import { test } from "node:test";
import assert from "node:assert/strict";
import { parseFrontmatterPaths, buildRulesSection } from "../claude-rules.ts";

test("parseFrontmatterPaths: extracts paths list", () => {
  const content = `---
paths:
  - "**/supabase/**"
---

# Supabase Rules
`;
  assert.deepEqual(parseFrontmatterPaths(content), ["**/supabase/**"]);
});

test("parseFrontmatterPaths: multiple paths including negative globs, order preserved", () => {
  const content = `---
paths:
  - "**/docs/*.md"
  - "**/notes/**/*.md"
  - "!**/.claude/**"
---
`;
  assert.deepEqual(parseFrontmatterPaths(content), [
    "**/docs/*.md",
    "**/notes/**/*.md",
    "!**/.claude/**",
  ]);
});

test("parseFrontmatterPaths: no frontmatter returns []", () => {
  assert.deepEqual(parseFrontmatterPaths("# Just a doc\n"), []);
});

test("parseFrontmatterPaths: frontmatter without paths key returns []", () => {
  const content = `---
name: something
---
`;
  assert.deepEqual(parseFrontmatterPaths(content), []);
});

test("parseFrontmatterPaths: unclosed frontmatter returns []", () => {
  const content = `---
paths:
  - "**/*.md"
`;
  assert.deepEqual(parseFrontmatterPaths(content), []);
});

test("buildRulesSection: renders glob -> file mapping", () => {
  const section = buildRulesSection(
    [
      { rel: "supabase/supabase.md", paths: ["**/supabase/**"] },
      { rel: "docs/markdown.md", paths: ["**/*.md"] },
    ],
    "/Users/x/.claude/rules",
  );
  assert.ok(section.includes("`**/supabase/**` → `/Users/x/.claude/rules/supabase/supabase.md`"));
  assert.ok(section.includes("`**/*.md` → `/Users/x/.claude/rules/docs/markdown.md`"));
});

test("buildRulesSection: multiple globs for one file on separate lines", () => {
  const section = buildRulesSection(
    [{ rel: "docs/docs.md", paths: ["**/docs/*.md", "!**/.claude/**"] }],
    "/Users/x/.claude/rules",
  );
  assert.ok(section.includes("`**/docs/*.md` → "));
  assert.ok(section.includes("`!**/.claude/**` → "));
});

test("buildRulesSection: rule without paths rendered as (general)", () => {
  const section = buildRulesSection([{ rel: "env/env.md", paths: [] }], "/Users/x/.claude/rules");
  assert.ok(section.includes("(general) `/Users/x/.claude/rules/env/env.md`"));
});

test("buildRulesSection: negative globs are advisory, not enforced", () => {
  const section = buildRulesSection(
    [{ rel: "docs/docs.md", paths: ["**/docs/*.md", "!**/.claude/**"] }],
    "/Users/x/.claude/rules",
  );
  assert.ok(
    section.includes("Globs prefixed with `!` are advisory notes for humans, not enforced exclusions."),
  );
});

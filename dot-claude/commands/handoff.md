---
description: Save the current conversation as a handoff markdown within 200 lines (run before the next /compact)
allowed-tools: Bash(mkdir *), Bash(date *), Bash(wc *), Write(**/docs/compacts/*.md)
---

# handoff

Analyze the current conversation state and save the info the next session should inherit as markdown within 200 lines.
Save it to `./docs/compacts/YYYY-MM-DD-HHMMSS.md`.
For `YYYY-MM-DD-HHMMSS`, use the value from running `date +%Y-%m-%d-%H%M%S` in Bash.

## Markdown structure to output

```markdown
# handoff — <one-line session theme>

## In-progress tasks

- What you are in the middle of doing
- How far you have progressed

## Decisions (and Why)

- What was decided and the reason

## Open questions / Next steps

- What to do next
- Points still pending a decision

## Files and commands touched

- Keep concrete paths, commands run, and error messages as-is
```

## Rules

- Strictly keep within 200 lines (human readability limit)
- If it might exceed, cut by importance
- Keep info concrete (paths, commands, error messages as-is)
- Do not write subjective summaries ("went well", "smooth", etc.)
- Write on a factual basis
- Omit sections that do not apply
- Follow the Format Rules (`dot-claude/rules/docs/format.md`)
  - One sentence per line, within 20 words for English
  - No `**Bold**`
  - No `---` around headings

## Steps

1. Run `mkdir -p ./docs/compacts` in Bash
2. Run `date +%Y-%m-%d-%H%M%S` in Bash and store it in a variable
3. Write the markdown with the structure above to `./docs/compacts/<timestamp>.md` with the Write tool
4. Run `wc -l` in Bash to check the line count
5. Report the generated file path and line count in one line

## Report format

After the work is done, report to the user in one line only.

```
docs/compacts/<filename>.md (N lines)
```

Do not write any other comment.

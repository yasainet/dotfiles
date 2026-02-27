# Workflow Orchestration

## Task Management

> [!IMPORTANT]
>
> - Follow these steps in order: Summary, Investigation, Planning, Execute, Verification
> - Get user confirmation before moving to the next step

1. Summary: Summarize the user's request. Confirm the goal and check for misunderstandings
2. Investigation: Search related files, web, and docs needed for the goal
3. Planning: Always use plan mode. Propose a TODO list for the implementation
4. Execute: Follow Core Principles below
5. Verification: Run the verification steps defined in the project's CLAUDE.md

## Core Principles

- YAGNI: You Aren't Gonna Need It
- KISS: Keep It Simple, Stupid
- DRY: Don't Repeat Yourself
- SRP: Single Responsibility Principle
- ESLint: Follow the linting rules defined in the project

## Code Comments, JSDoc

- Write all code comments and JSDoc descriptions in simple English
- Use bullet list format when the description gets long
- Only use `@description`. No other JSDoc tags
- Describe "why" this code exists, not the implementation details

---

> [!NOTE]
> Capture Lessons: If the user points out, record it in `~/.claude/rules/lessons.md`

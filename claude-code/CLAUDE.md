# Workflow Orchestration

## Task Management

> [!IMPORTANT]
>
> - Follow these steps in order: Summary, Investigation, Planning, Execute, Verification
> - Get user confirmation before moving to the next step

1. Summary: Summarize the user's request. Confirm the goal and check for misunderstandings
2. Investigation: Search related files, web, and docs needed for the goal
3. Planning: Always use `Plan mode`. Propose a TODO list for the implementation
4. Execute: Follow Core Principles below
5. Verification: Run the verification steps defined in the project's CLAUDE.md

## Plan to Issue

- Create an issue with `gh issue create` once a `Plan` is finalized
- Issue template:

```markdown
## Why

(Purpose — why this needs to be solved)

## How

(Strategy — how to solve it)

## What

(Tactics — what to implement)

- [ ] task 1
- [ ] task 2
```

### Linking commits to issues

- Include `Closes #N` in commit messages to auto-close issues when merged into main

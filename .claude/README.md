# .claude

Claude Code configuration files.

## Commands

**settings.local.json**:

```vim
:%!jq '.permissions.allow |= sort | .permissions.deny |= sort'
```


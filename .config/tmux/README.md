# tmux README

## USAGE

### Prefix

All commands start with `C-a` (Ctrl+a).

### Session

| Key | Description |
|-----|-------------|
| `C-a d` | Detach from session |
| `C-a s` | List sessions |
| `C-a $` | Rename session |

```sh
tmux                    # Start new session
tmux new -s <name>      # Start new session with name
tmux ls                 # List sessions
tmux a                  # Attach to last session
tmux a -t <name>        # Attach to named session
tmux kill-session -t <name>  # Kill session
```

### Window

| Key | Description |
|-----|-------------|
| `C-a c` | Create new window |
| `C-a ,` | Rename window |
| `C-a &` | Close window |
| `C-a w` | List windows |
| `M-1` ~ `M-9` | Switch to window 1-9 (Alt+number) |
| `M-[` | Previous window |
| `M-]` | Next window |
| `C-a .` | Move window to specified number |
| `C-a :swap-window -t <n>` | Swap with window n |
| `C-a :swap-window -s 2 -t 1` | Swap window 2 and 1 |

### Pane

| Key | Description |
|-----|-------------|
| `C-a %` | Split vertically |
| `C-a "` | Split horizontally |
| `C-a x` | Close pane |
| `C-a o` | Move to next pane |
| `C-a ;` | Move to last pane |
| `C-a ↑↓←→` | Move between panes |
| `C-a z` | Toggle pane zoom |
| `C-a {` | Swap pane left |
| `C-a }` | Swap pane right |
| `C-a Space` | Cycle pane layouts |

### Copy Mode (vi)

| Key | Description |
|-----|-------------|
| `C-a [` | Enter copy mode |
| `v` | Begin selection |
| `C-v` | Toggle rectangle selection |
| `y` | Yank (copy) selection |
| `q` | Exit copy mode |

### Resize Pane

| Key | Description |
|-----|-------------|
| `C-a C-↑↓←→` | Resize pane (hold Ctrl) |
| `C-a M-↑↓←→` | Resize pane by 5 cells |

### Misc

| Key | Description |
|-----|-------------|
| `C-a ?` | List all keybindings |
| `C-a :` | Command prompt |
| `C-a t` | Show clock |

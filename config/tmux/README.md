# tmux README

## USAGE

### Prefix

All commands start with `C-b` (Ctrl+b).

### Session

| Key                  | Description              |
| -------------------- | ------------------------ |
| `C-b d`              | Detach from session      |
| `C-b s`              | List sessions            |
| `C-b $`              | Rename session           |
| `C-b :new`           | Create new session       |
| `C-b :new -s <name>` | Create new named session |
| `C-b :kill-session`  | Kill current session     |

#### Tree View (C-b s / C-b w)

| Key         | Description             |
| ----------- | ----------------------- |
| `$`         | Rename session          |
| `x`         | Kill session/window     |
| `Enter`     | Switch to selected item |
| `←` / `h`   | Collapse tree           |
| `→` / `l`   | Expand tree             |
| `q` / `Esc` | Exit tree view          |
| `O`         | Sort (index/name/time)  |

```sh
tmux                    # Start new session
tmux new -s <name>      # Start new session with name
tmux ls                 # List sessions
tmux a                  # Attach to last session
tmux a -t <name>        # Attach to named session
tmux kill-session -t <name>  # Kill session
```

### Session Restore (tmux-resurrect)

| Key       | Description     |
| --------- | --------------- |
| `C-b C-s` | Save session    |
| `C-b C-r` | Restore session |

### Window

| Key                          | Description                       |
| ---------------------------- | --------------------------------- |
| `C-b c`                      | Create new window after current   |
| `C-b ,`                      | Rename window                     |
| `C-b &`                      | Close window                      |
| `C-b w`                      | List windows                      |
| `M-1` ~ `M-9`                | Switch to window 1-9 (Alt+number) |
| `M-[`                        | Previous window                   |
| `M-]`                        | Next window                       |
| `C-b .`                      | Move window to specified number   |
| `C-b :swap-window -t <n>`    | Swap with window n                |
| `C-b :swap-window -s 2 -t 1` | Swap window 2 and 1               |

### Pane

| Key         | Description        |
| ----------- | ------------------ |
| `C-b %`     | Split vertically   |
| `C-b "`     | Split horizontally |
| `C-b x`     | Close pane         |
| `C-b o`     | Move to next pane  |
| `C-b ;`     | Move to last pane  |
| `C-b ↑↓←→`  | Move between panes |
| `C-b z`     | Toggle pane zoom   |
| `C-b {`     | Swap pane left     |
| `C-b }`     | Swap pane right    |
| `C-b Space` | Cycle pane layouts |

### Copy Mode (vi)

| Key     | Description                |
| ------- | -------------------------- |
| `C-b [` | Enter copy mode            |
| `v`     | Begin selection            |
| `C-v`   | Toggle rectangle selection |
| `y`     | Yank (copy) selection      |
| `q`     | Exit copy mode             |

### Resize Pane

| Key                        | Description             |
| -------------------------- | ----------------------- |
| `C-b C-↑↓←→`               | Resize pane (hold Ctrl) |
| `C-b M-↑↓←→`               | Resize pane by 5 cells  |
| `C-b :resize-pane -D <n>`  | Resize down by n cells  |
| `C-b :resize-pane -U <n>`  | Resize up by n cells    |
| `C-b :resize-pane -L <n>`  | Resize left by n cells  |
| `C-b :resize-pane -R <n>`  | Resize right by n cells |
| `C-b :resize-pane -x <n>%` | Set pane width to n%    |
| `C-b :resize-pane -y <n>%` | Set pane height to n%   |

### Misc

| Key     | Description          |
| ------- | -------------------- |
| `C-b ?` | List all keybindings |
| `C-b :` | Command prompt       |
| `C-b t` | Show clock           |

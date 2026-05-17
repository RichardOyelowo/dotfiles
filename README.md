# Dotfiles

Personal Linux, terminal, tmux, Git, shell, and Neovim config.

## Install

Run from the repo root:

```sh
stow -t "$HOME" git kitty lazygit nvim scripts tmux wezterm zsh
```

To preview changes first:

```sh
stow -n -v -t "$HOME" git kitty lazygit nvim scripts tmux wezterm zsh
```

To remove links:

```sh
stow -D -t "$HOME" git kitty lazygit nvim scripts tmux wezterm zsh
```

## tmux Workflow

Open a terminal and run:

```sh
tmux
```

Inside tmux, press `Ctrl-b o` to open the project picker. Choosing a project creates or switches to a session for that project.

New project sessions open with:

- `editor`: `nvim .`
- `shell`: a normal shell

Use `Ctrl-b g` for `lazygit` in a popup from the current directory.

### Prefix

This config uses the default tmux prefix:

```text
Ctrl-b
```

When a command says `prefix`, press `Ctrl-b`, release it, then press the next key.

### Copy Text

Mouse mode is enabled in tmux:

```tmux
set -g mouse on
```

That means tmux captures normal mouse drag. To copy with the terminal instead of tmux:

1. Hold `Shift`.
2. Drag to highlight text.
3. Press `Ctrl-Shift-c` in the terminal.

To copy with tmux:

1. Press `Ctrl-b [`.
2. Move with `h`, `j`, `k`, `l`, arrow keys, or the mouse wheel.
3. Press `Space` to start selection.
4. Move to the end of the text.
5. Press `Enter` to copy.
6. Press `Ctrl-b ]` to paste inside tmux.

This config has `set -g set-clipboard on`, so tmux should ask the terminal to copy to the system clipboard. If system clipboard copy ever fails, add explicit Wayland copy bindings:

```tmux
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send -X copy-pipe-and-cancel "wl-copy"
bind -T copy-mode-vi Enter send -X copy-pipe-and-cancel "wl-copy"
bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "wl-copy"
```

### Panes

Create panes:

```text
Ctrl-b \    split left and right
Ctrl-b -    split top and bottom
```

Move between panes:

```text
Ctrl-b h    left
Ctrl-b j    down
Ctrl-b k    up
Ctrl-b l    right
```

Resize panes:

```text
Ctrl-b H    resize left
Ctrl-b J    resize down
Ctrl-b K    resize up
Ctrl-b L    resize right
```

Useful built-in pane commands:

```text
Ctrl-b x    kill current pane
Ctrl-b z    zoom or unzoom current pane
Ctrl-b q    show pane numbers
```

### Windows

Useful built-in window commands:

```text
Ctrl-b c    create window
Ctrl-b ,    rename current window
Ctrl-b n    next window
Ctrl-b p    previous window
Ctrl-b 1    go to window 1
Ctrl-b 2    go to window 2
Ctrl-b &    kill current window
```

Windows and panes start at `1` in this config.

### Sessions

Project sessions:

```text
Ctrl-b o    project picker popup
Ctrl-b O    project picker full command
Ctrl-b X    kill current session
```

Useful built-in session commands:

```text
Ctrl-b d    detach from session
Ctrl-b s    choose session
tmux ls     list sessions
tmux attach -t name
tmux kill-session -t name
```

Reload tmux after editing the config:

```text
Ctrl-b r
```

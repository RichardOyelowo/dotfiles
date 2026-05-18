# Dotfiles

Personal Linux configuration for terminals, tmux, zsh, Git, Lazygit, scripts, and Neovim.

This setup keeps the terminal calm by default. Kitty opens into a normal zsh shell. Development starts when tmux is launched. WezTerm can use the same workflow, but it remains the main development terminal.

## Layout

| Path | Purpose |
| --- | --- |
| `git` | Git defaults and aliases |
| `kitty` | Kitty terminal theme, opacity, blur, shell behavior, and key behavior |
| `lazygit` | Lazygit interface settings |
| `nvim` | Neovim configuration based on LazyVim |
| `scripts` | Local helper scripts used by the desktop workflow |
| `tmux` | Project sessions, panes, popups, copy mode, and status line |
| `wezterm` | WezTerm terminal settings for the main development flow |
| `zsh` | Interactive shell configuration |

## Install

Run from the repo root:

```sh
stow -t "$HOME" git kitty lazygit nvim scripts tmux wezterm zsh
```

Preview the links first:

```sh
stow -n -v -t "$HOME" git kitty lazygit nvim scripts tmux wezterm zsh
```

Remove the links:

```sh
stow -D -t "$HOME" git kitty lazygit nvim scripts tmux wezterm zsh
```

## Terminal Setup

Kitty and WezTerm both use zsh as the normal interactive shell. Neither terminal should force a tmux session on startup. That keeps quick shell work simple.

The development flow starts when tmux is launched:

```sh
tmux
```

Both terminal emulators use a transparent background with blur:

| Terminal | Opacity | Blur |
| --- | --- | --- |
| Kitty | `0.84` | `background_blur 18` |
| WezTerm | `0.84` | KDE blur enabled, macOS blur set to `20` |

Kitty is best for a clean shell window. WezTerm remains the main development terminal. The workflow is the same in both terminals once tmux starts.

## Shell

zsh owns the interactive shell experience. Keep login and interactive shell behavior in the zsh files, not inside Kitty or WezTerm. Terminal config should decide window behavior. Shell config should decide aliases, environment, prompt setup, and command behavior.

Starship provides the prompt when installed. If Starship is missing, zsh should still start normally.

## tmux Workflow

Open tmux from any terminal:

```sh
tmux
```

Inside tmux, press `Ctrl-b o` to open the project picker. Choosing a project creates or switches to a session for that project.

New project sessions open with:

- `editor`: `nvim .`
- `shell`: a normal shell

Use `Ctrl-b g` for Lazygit in a popup from the current directory.

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

tmux captures a normal mouse drag when mouse mode is on. To copy with the terminal instead of tmux:

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

This config has `set -g set-clipboard on`, so tmux should ask the terminal to copy to the system clipboard. If system clipboard copy fails, add explicit Wayland copy bindings:

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

Useful pane commands:

```text
Ctrl-b x    kill current pane
Ctrl-b z    zoom or unzoom current pane
Ctrl-b q    show pane numbers
```

### Windows

Useful window commands:

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

Useful session commands:

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

## Neovim

Neovim is based on LazyVim. Plugin files live in `nvim/.config/nvim/lua/plugins`. Core editor settings, keymaps, and startup behavior live in `nvim/.config/nvim/lua/config`.

The setup includes:

- Snacks for picker, explorer, file search, and UI helpers.
- Blink for completion.
- Mason for installing LSP servers and developer tools.
- nvim-lspconfig for connecting Neovim to installed language servers.
- Trouble for diagnostics and workspace problem views.
- todo-comments for finding TODO, FIXME, and related notes.
- nvim-dap for debugging.
- mini.icons for file icons.
- Incline for the current file label.
- inc-rename for previewed symbol renames.
- refactoring.nvim for extraction and inline refactors.
- rest.nvim for `.http` request files.
- ChatForge for local chat commands.

The bufferline tab strip is disabled because Incline already shows the active file. Hidden files are visible in the file explorer and picker.

### Neovim Key Notes

Undo is the built-in `u`. Redo is mapped to `U`, which sends Neovim's built-in `<C-r>`.

Rename uses:

```text
<leader>r
```

Refactoring uses uppercase leader mappings:

```text
<leader>Rs    select refactor
<leader>Re    extract function
<leader>RF    extract function to file
<leader>Rv    extract variable
<leader>Ri    inline variable
<leader>RI    inline function
```

REST requests use:

```text
<leader>ar    run request
<leader>al    run last request
<leader>ao    open response
<leader>ae    edit environment
<leader>ac    select cookie
<leader>ag    select request
```

### LSP Notes

Mason installs external tools. nvim-lspconfig configures Neovim to talk to language servers. They work together, but they solve different problems.

Mason should stay as the tool installer. LSP config belongs in its own LSP plugin file or in the existing LazyVim LSP override. That keeps installation separate from editor behavior.

## Git And Lazygit

Git config lives in `git`. Lazygit has its own directory so terminal Git UI behavior stays separate from global Git defaults.

Inside tmux, `Ctrl-b g` opens Lazygit in a popup. Outside tmux, run `lazygit` normally.

## Maintenance

After editing Neovim Lua files, run:

```sh
stylua nvim/.config/nvim/lua
nvim --headless '+qa'
```

After editing terminal config, validate startup:

```sh
kitty -c "$PWD/kitty/.config/kitty/kitty.conf" --start-as hidden true
wezterm --config-file "$PWD/wezterm/.config/wezterm/wezterm.lua" show-keys
```

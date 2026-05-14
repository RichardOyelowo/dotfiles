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

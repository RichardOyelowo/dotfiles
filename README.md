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

Kitty opens a normal zsh shell. WezTerm opens the tmux project picker directly because it is the main development terminal.

In Kitty, the development flow starts when tmux is launched:

```sh
tmux
```

Both terminal emulators use a lightly transparent background without compositor blur:

| Terminal | Opacity | Blur |
| --- | --- | --- |
| Kitty | `0.84` | disabled |
| WezTerm | `0.84` | disabled |

Kitty is best for a clean shell window. WezTerm remains the main development terminal. The workflow is the same in both terminals once tmux starts.

WezTerm can load private machine-local settings from `local.lua`. Use `wezterm/.config/wezterm/local.example.lua` as the template. The real `local.lua` file is ignored by Git, so absolute local paths stay out of the repo. If no local file is found, WezTerm uses the normal configured background and opacity.

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

### Diagnostics And Tooling

Mason installs external tools. `nvim-lspconfig` connects Neovim to language servers. `nvim-lint` runs extra linters after save and when leaving insert mode. Conform formats on save with an 800ms timeout and falls back to LSP formatting when no formatter is configured.

Diagnostics come from LSP servers and linters. They show virtual text, underlines, and sorted severity. Diagnostics do not update while typing because `update_in_insert` is off. That keeps half-written lines from producing noisy messages.

Tool installation belongs in `nvim/.config/nvim/lua/plugins/mason.lua`. Editor behavior belongs in `lsp.lua`, `lint.lua`, and `conform.lua`. Project detection helpers live in `nvim/.config/nvim/lua/config/project_tools.lua`. The local diagnostic display filter lives in `nvim/.config/nvim/lua/config/diagnostics.lua`.

### Project Tool Detection

Python uses this interpreter order:

1. Project-local `.venv`
2. Project-local `venv`
3. Project-local `env`
4. Project-local `.env`
5. Active `VIRTUAL_ENV`, only when it is inside the project root
6. `python3` from `PATH`
7. `python` as the final fallback

Pyright receives the detected path as `python.pythonPath`. Ruff LSP receives the same interpreter path. That keeps LSP import resolution and lint diagnostics tied to the same environment. Conform and `nvim-lint` still run their configured Ruff executables.

TypeScript uses `node_modules/typescript/lib` when the project has it. That keeps `vtsls` on the project's TypeScript version. If no local TypeScript SDK exists, `vtsls` uses its default.

The CLI launcher uses similar local lookup rules for `<leader>r` and `<leader>i`. It checks Python virtual environments, `node_modules/.bin`, project command paths, and then `PATH`. It can run Python, JavaScript, TypeScript, Rust, Go, C, C++, Lua, shell, and bash files. It can install packages for Python, JavaScript, TypeScript, Rust, and Go.

C and C++ do not use project tool lookup. `clangd` needs a compile database, usually `compile_commands.json`. Generate one from CMake, Bear, Meson, or the build tool when includes or compiler flags are missing.

### Tool Ownership

| Language | LSP | Lint | Format | Notes |
| --- | --- | --- | --- | --- |
| Python | `pyright`, `ruff` | `ruff` | `ruff_format`, `ruff_organize_imports` | Pyright owns types and imports. Ruff owns lint, format, and import cleanup. Pyright unused import warnings are disabled. |
| TypeScript, JavaScript, TSX, JSX | `vtsls` | `biomejs` | `biome`, then `prettier` | Biome is tried first. Prettier is the fallback formatter. `eslint_d` is installed but not wired to `nvim-lint`. |
| Shell, Bash, Zsh | none | `shellcheck` for `sh` | `shfmt` | `bash` and `zsh` format with `shfmt`. Only `sh` is wired to ShellCheck in `lint.lua`. |
| C, C++ | `clangd` | `clangtidy` | `clang-format` | `clangd` needs project compile flags for accurate results. |
| Lua | `lua_ls` | none | `stylua` | `vim` is registered as a Lua global. |
| JSON, JSONC | `jsonls` | none | `biome`, then `prettier` | JSONC uses the same formatter chain. |
| YAML | `yamlls` | none | `prettier` | YAML support also comes from the LazyVim YAML extra. |
| TOML | none | none | `taplo` | Mason installs Taplo for formatting. |
| Markdown, MDX | LazyVim Markdown tooling | none | `prettier` | Render and preview keymaps live in `keymaps.lua`. |
| SQL | LazyVim SQL tooling | none | `sqlfluff` | Formatting depends on the project's SQLFluff config when one exists. |
| Dockerfile | LazyVim Docker tooling | none | `dockerfmt` | `dockerfmt` is configured in Conform, but it is not installed by Mason in this config. |
| HTML | `html` | none | `prettier` | HTML LSP comes from `html-lsp`. |
| CSS | `cssls` | none | `biome`, then `prettier` | CSS LSP comes from `css-lsp`. |
| SCSS, Less | none | none | `prettier` | These use formatter support only in this config. |
| Rust | LazyVim Rust tooling | none | `rustfmt` | Rust support comes from the LazyVim Rust extra and Conform. |

Mason also installs DAP adapters: `debugpy`, `codelldb`, and `js-debug-adapter`. `mason-nvim-dap` maps them as `python`, `codelldb`, and `js`.

Mason installs `black`, but Python formatting currently uses Ruff through Conform. Keep Black installed only if you want it available outside this formatter chain.

### Local Diagnostic Ignore

Neovim hides virtual text, signs, underline, and other diagnostic display output on any line with one of these markers:

```text
nvim-diagnostic-ignore
# ignore
// ignore
-- ignore
/* ignore */
<!-- ignore -->
```

Use it inside the comment syntax for the current language:

```python
value = call_external_api()  # nvim-diagnostic-ignore
```

```ts
const value = callExternalApi() // nvim-diagnostic-ignore
```

```lua
local value = external_value -- nvim-diagnostic-ignore
```

This only filters Neovim's diagnostic display handlers. `vim.diagnostic.get()`, Trouble, CI, language servers, and command-line linters still see the diagnostic. For committed code, use the language-native suppression when one exists.

### Suppression Examples

Use narrow suppressions. Prefer one line over a whole file.

Python Ruff:

```python
import os  # noqa: F401
```

Python Pyright:

```python
value = unknown_api()  # pyright: ignore[reportUnknownVariableType]
```

TypeScript and JavaScript with Biome:

```ts
// biome-ignore lint/suspicious/noExplicitAny: external API returns mixed data
const payload: any = readPayload()
```

TypeScript checker:

```ts
// @ts-expect-error external package has stale types
legacyCall(value)
```

ShellCheck:

```sh
# shellcheck disable=SC2086
cmd $args
```

C and C++ with clang-tidy:

```c
int value = legacy_call(); // NOLINT(readability-identifier-naming)
```

Lua language server:

```lua
---@diagnostic disable-next-line: undefined-global
local value = external_value
```

JSON:

```json
{
  "comment": "JSON has no standard inline diagnostic suppression. Fix the rule or exclude the file in the tool config."
}
```

YAML:

```yaml
# YAML diagnostics here come from yamlls. Prefer fixing the schema issue or moving generated data out of the checked file.
description: "Long generated value" # nvim-diagnostic-ignore
```

TOML:

```toml
# TOML has no standard inline diagnostic suppression for Taplo formatting.
name = "example"
```

Markdown:

```markdown
<!-- prettier-ignore -->
This line is intentionally spaced    by generated output.
```

SQL with SQLFluff:

```sql
SELECT * FROM users; -- noqa: LT09
```

Dockerfile with Hadolint-style comments:

```dockerfile
# Dockerfile linting is not wired in this config. Use nvim-diagnostic-ignore only for Neovim display noise.
RUN apt-get update && apt-get install -y curl # nvim-diagnostic-ignore
```

HTML:

```html
<!-- prettier-ignore -->
<div class="generated    spacing"></div>
```

CSS, SCSS, and Less:

```css
/* prettier-ignore */
.button { display: block !important; }
```

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

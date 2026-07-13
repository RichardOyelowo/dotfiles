# ------------------------------
# SSH Agent
# ------------------------------
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)" >/dev/null
  ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi

# ------------------------------
# Powerlevel10k Instant Prompt
# ------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# ------------------------------
# Oh My Zsh
# ------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# ------------------------------
# History
# ------------------------------
HISTFILE="$HOME/.histfile"
HISTSIZE=50000
SAVEHIST=50000

# ------------------------------
# Environment
# ------------------------------
export EDITOR="nvim"
export SHELL="/usr/bin/zsh"

export PATH="$HOME/.local/bin:$PATH:/usr/local/go/bin:/var/lib/snapd/snap/bin:/snap/bin"

# ------------------------------
# zoxide
# ------------------------------
eval "$(zoxide init zsh)"

# ------------------------------
# nvm
# ------------------------------
export NVM_DIR="$HOME/.nvm"

load_nvm() {
  unset -f nvm node npm npx corepack
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
}

nvm()      { load_nvm; nvm "$@"; }
node()     { load_nvm; node "$@"; }
npm()      { load_nvm; npm "$@"; }
npx()      { load_nvm; npx "$@"; }
corepack() { load_nvm; corepack "$@"; }

# ------------------------------
# Aliases
# ------------------------------
alias ls="eza --icons"
alias ll="eza -lah --icons"
alias tree="eza --tree --icons"

alias cat="bat"

alias gst="git status"
alias gd="git diff"
alias gp="git push"
alias gl="git log --oneline --graph --decorate"

alias lg="lazygit"

# ------------------------------
# Auto tmux
# ------------------------------
if command -v tmux >/dev/null \
  && [[ -z "$TMUX" ]] \
  && [[ "$DEV_TMUX" == "1" ]] \
  && [[ $- == *i* ]] \
  && [[ -t 1 ]]; then

  if command -v tmux-sessionizer >/dev/null; then
    tmux-sessionizer
  else
    tmux attach-session -t main 2>/dev/null || tmux new-session -s main
  fi
fi

# ------------------------------
# Powerlevel10k Config
# ------------------------------
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh


# Added by Antigravity CLI installer
export PATH="/home/Richard_O/.local/bin:$PATH"

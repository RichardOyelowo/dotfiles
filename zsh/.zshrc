# ------------------------------
# SSH Agent
# ------------------------------
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)" > /dev/null
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

source $ZSH/oh-my-zsh.sh

# ------------------------------
# History
# ------------------------------
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000

# ------------------------------
# Environment
# ------------------------------
export EDITOR="nvim"
export SHELL="/usr/bin/zsh"

# PATH
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

# ------------------------------
# zoxide
# ------------------------------
eval "$(zoxide init zsh)"

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

# ------------------------------
# Auto tmux
# ------------------------------
if command -v tmux &> /dev/null \
  && [ -z "$TMUX" ] \
  && [[ $- == *i* ]] \
  && [ -t 1 ]; then

  if command -v tmux-sessionizer &> /dev/null; then
    tmux-sessionizer
  else
    tmux attach-session -t main 2>/dev/null || tmux new-session -s main
  fi
fi

# ------------------------------
# Powerlevel10k Config
# ------------------------------
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

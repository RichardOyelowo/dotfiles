#!/usr/bin/env bash
# my dotfiles installer
# works on debian/ubuntu, fedora, arch, opensuse and mac (brew)
# usage: ./install.sh [--no-packages]
# --no-packages just links the dotfiles and skips installing stuff

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# folders in the repo that get stowed into $HOME
PACKAGES=(git kitty lazygit nvim scripts tmux wezterm zsh)

# command:package, so i can check for the command and install the package
TOOLS=("git:git" "stow:stow" "zsh:zsh" "tmux:tmux" "rg:ripgrep" "zoxide:zoxide" "nvim:neovim")

BACKUP_SUFFIX=".bak.$(date +%Y%m%d%H%M%S)"
INSTALL_PACKAGES=1
FAILED=0

log()  { printf '==> %s\n' "$*"; }
warn() { printf 'warning: %s\n' "$*" >&2; }
have() { command -v "$1" >/dev/null 2>&1; }

usage() {
  echo "usage: ./install.sh [--no-packages]"
}

for arg in "$@"; do
  case "$arg" in
    --no-packages) INSTALL_PACKAGES=0 ;;
    -h|--help) usage; exit 0 ;;
    *) warn "don't know this option: $arg"; usage; exit 1 ;;
  esac
done

# use sudo unless i'm already root
if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
  SUDO=""
elif have sudo; then
  SUDO="sudo"
else
  SUDO=""
fi

# figure out which package manager this machine has
detect_pm() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    if have brew; then echo brew; else echo none; fi
    return
  fi
  local pm
  for pm in apt-get dnf pacman zypper; do
    if have "$pm"; then echo "$pm"; return; fi
  done
  echo none
}

PM="$(detect_pm)"

pkg_install() {
  case "$PM" in
    apt-get) $SUDO apt-get install -y "$@" ;;
    dnf)     $SUDO dnf install -y "$@" ;;
    pacman)  $SUDO pacman -S --needed --noconfirm "$@" ;;
    zypper)  $SUDO zypper --non-interactive install "$@" ;;
    brew)    brew install "$@" ;;
    *)       return 1 ;;
  esac
}

# apt neovim is always super old so grab the official release instead
install_neovim_tarball() {
  local asset tmp
  case "$(uname -m)" in
    x86_64)        asset="nvim-linux-x86_64" ;;
    aarch64|arm64) asset="nvim-linux-arm64" ;;
    *) warn "no prebuilt neovim for $(uname -m), install it yourself"; return 1 ;;
  esac
  have curl || pkg_install curl
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/nvim.tar.gz" \
    "https://github.com/neovim/neovim/releases/latest/download/${asset}.tar.gz"
  $SUDO rm -rf "/opt/${asset}"
  $SUDO tar -C /opt -xzf "$tmp/nvim.tar.gz"
  $SUDO ln -sf "/opt/${asset}/bin/nvim" /usr/local/bin/nvim
  rm -rf "$tmp"
}

install_packages() {
  if [[ "$PM" == "none" ]]; then
    warn "no package manager found, install these yourself: ${TOOLS[*]##*:}"
    return 0
  fi

  log "using $PM"
  case "$PM" in
    apt-get) $SUDO apt-get update ;;
    zypper)  $SUDO zypper --non-interactive refresh ;;
    brew)    brew update ;;
  esac

  local entry cmd pkg
  for entry in "${TOOLS[@]}"; do
    cmd="${entry%%:*}"
    pkg="${entry##*:}"
    # already got it, move on
    if have "$cmd"; then
      continue
    fi
    log "installing $pkg"
    if [[ "$cmd" == "nvim" && "$PM" == "apt-get" ]]; then
      install_neovim_tarball || warn "neovim install failed"
    else
      pkg_install "$pkg" || warn "couldn't install $pkg, do it by hand"
    fi
  done
}

# if a real file is already sitting where a symlink should go, move it
# out of the way so stow doesn't blow up (and i don't lose anything)
backup_conflicts() {
  local pkg="$1" src rel dst
  while IFS= read -r -d '' src; do
    rel="${src#"$DOTFILES_DIR/$pkg/"}"
    dst="$HOME/$rel"
    if [[ -e "$dst" || -L "$dst" ]] && ! [[ "$src" -ef "$dst" ]]; then
      log "moving $dst to $dst$BACKUP_SUFFIX"
      mv "$dst" "$dst$BACKUP_SUFFIX"
    fi
  done < <(find "$DOTFILES_DIR/$pkg" -type f -print0)
}

link_dotfiles() {
  if ! have stow; then
    warn "stow isn't installed, can't link anything"
    exit 1
  fi

  local pkg
  for pkg in "${PACKAGES[@]}"; do
    if [[ ! -d "$DOTFILES_DIR/$pkg" ]]; then
      warn "no $pkg folder, skipping"
      continue
    fi
    backup_conflicts "$pkg"
    log "linking $pkg"
    if ! stow --restow --dir "$DOTFILES_DIR" --target "$HOME" "$pkg"; then
      warn "stow failed on $pkg"
      FAILED=1
    fi
  done
}

if [[ "$INSTALL_PACKAGES" -eq 1 ]]; then
  install_packages
fi

link_dotfiles

echo
if [[ "$FAILED" -eq 0 ]]; then
  log "all done"
else
  warn "finished but something failed, check above"
fi

# reminders
if have zsh && [[ "$(basename "${SHELL:-}")" != "zsh" ]]; then
  echo "reminder: chsh -s \"\$(command -v zsh)\" to make zsh the default shell"
fi
echo "reminder: p10k needs a nerd font (MesloLGS NF) set in the terminal"

exit "$FAILED"

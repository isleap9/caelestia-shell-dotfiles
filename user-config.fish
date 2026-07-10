#!/usr/bin/env bash
# Fresh Arch bootstrap: caelestia dots + personal dotfiles
# Run as your normal user (NOT root) after first boot + login.
set -euo pipefail

# ─── EDIT THESE ──────────────────────────────────────────────
DOTFILES_REPO="https://github.com/YOURUSER/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
# Extra packages you always want (space separated)
EXTRA_PKGS="firefox neovim htop unzip"
EXTRA_AUR_PKGS=""
# ─────────────────────────────────────────────────────────────

msg() { printf '\n\033[1;35m==> %s\033[0m\n' "$*"; }

[[ $EUID -eq 0 ]] && { echo "Run as your user, not root."; exit 1; }

msg "Updating system"
sudo pacman -Syu --noconfirm

msg "Installing base tools"
sudo pacman -S --needed --noconfirm base-devel git fish

# ─── AUR helper (paru) ───────────────────────────────────────
if ! command -v paru &>/dev/null && ! command -v yay &>/dev/null; then
    msg "Installing paru"
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/paru-bin.git "$tmpdir/paru-bin"
    (cd "$tmpdir/paru-bin" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
fi
AUR=$(command -v paru || command -v yay)

# ─── Caelestia ───────────────────────────────────────────────
msg "Installing caelestia-cli and running caelestia install"
"$AUR" -S --needed --noconfirm caelestia-cli
caelestia install   # add flags here if you use them, e.g. --noconfirm

# ─── Personal dotfiles ───────────────────────────────────────
msg "Cloning personal dotfiles"
if [[ -d $DOTFILES_DIR ]]; then
    git -C "$DOTFILES_DIR" pull
else
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# Apply them: pick ONE of these, depending on how your repo is laid out.
# Option A: repo has an install/apply script
# "$DOTFILES_DIR/install.sh"
#
# Option B: GNU stow layout (one folder per app)
# sudo pacman -S --needed --noconfirm stow
# (cd "$DOTFILES_DIR" && stow -t "$HOME" */)
#
# Option C: plain copy of a .config dir (overwrites caelestia defaults!)
# cp -rT "$DOTFILES_DIR/.config" "$HOME/.config"

# ─── Extra packages ──────────────────────────────────────────
[[ -n $EXTRA_PKGS ]] && sudo pacman -S --needed --noconfirm $EXTRA_PKGS
[[ -n $EXTRA_AUR_PKGS ]] && "$AUR" -S --needed --noconfirm $EXTRA_AUR_PKGS

msg "Done! Reboot or log into Hyprland. (Caelestia ships no login manager — install greetd/sddm if you want one.)"

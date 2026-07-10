#!/usr/bin/env bash
# Fresh Arch bootstrap: caelestia (full install) + personal dotfiles
# Run as your normal user (NOT root) after first boot + login.
set -euo pipefail

# ─── EDIT IF NEEDED ──────────────────────────────────────────
DOTFILES_REPO="https://github.com/isleap9/caelestia-shell-dotfiles"
DOTFILES_DIR="$HOME/Documents/GitHub/caelestia-shell-dotfiles"

EXTRA_PKGS="firefox micro fastfetch htop unzip gcc make cmake git nano vim \
power-profiles-daemon rust wget curl perl \
linux-headers nvidia-dkms nvidia-utils nvidia-settings \
ttf-jetbrains-mono-nerd ttf-firacode-nerd ttf-nerd-fonts-symbols \
otf-font-awesome noto-fonts-cjk greetd greetd-tuigreet"

EXTRA_AUR_PKGS="bibata-cursor-theme ttf-rubik-vf ttf-google-sans google-chrome"
# ─────────────────────────────────────────────────────────────

msg() { printf '\n\033[1;35m==> %s\033[0m\n' "$*"; }
[[ $EUID -eq 0 ]] && { echo "Run as your user, not root."; exit 1; }

msg "Updating system"
sudo pacman -Syu --noconfirm

msg "Installing base tools"
sudo pacman -S --needed --noconfirm base-devel git fish

# ─── AUR helper (paru) ───────────────────────────────────────
if ! paru --version &>/dev/null && ! yay --version &>/dev/null; then
    msg "Installing paru"
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/paru.git "$tmpdir/paru"
    (cd "$tmpdir/paru" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
fi
AUR=$(command -v paru || command -v yay)

# ─── Caelestia (all extras) ──────────────────────────────────
msg "Installing caelestia with all extras"
"$AUR" -S --needed --noconfirm caelestia-cli
# NOTE: verify flag names with `caelestia install -h` before first real use
caelestia install

# ─── Personal dotfiles ───────────────────────────────────────
msg "Restoring personal dotfiles"
if [[ -d $DOTFILES_DIR ]]; then
    git -C "$DOTFILES_DIR" pull || true
else
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# Overlay personal configs ON TOP of caelestia defaults
if [[ -d $DOTFILES_DIR/config ]]; then
    for d in "$DOTFILES_DIR/config/"*/; do
        name=$(basename "$d")
        mkdir -p "$HOME/.config/$name"
        cp -rT "$d" "$HOME/.config/$name"
        echo "applied config: $name"
    done
fi

# Wallpapers
if [[ -d $DOTFILES_DIR/wallpapers ]]; then
    mkdir -p "$HOME/Pictures/Wallpapers"
    cp -rT "$DOTFILES_DIR/wallpapers" "$HOME/Pictures/Wallpapers"
    echo "applied: wallpapers"
fi

# ─── Extra packages ──────────────────────────────────────────
msg "Installing extra packages"
[[ -n $EXTRA_PKGS ]] && sudo pacman -S --needed --noconfirm $EXTRA_PKGS
[[ -n $EXTRA_AUR_PKGS ]] && "$AUR" -S --needed --noconfirm $EXTRA_AUR_PKGS

# ─── Login manager (greetd + tuigreet) ───────────────────────
msg "Configuring greetd"
if [[ -f $DOTFILES_DIR/etc/greetd/config.toml ]]; then
    # Use your own config if it's in the repo
    sudo install -Dm644 "$DOTFILES_DIR/etc/greetd/config.toml" /etc/greetd/config.toml
else
    sudo tee /etc/greetd/config.toml >/dev/null <<'EOF'
[terminal]
vt = 1

[default_session]
command = "tuigreet --time --remember --cmd Hyprland"
user = "greeter"
EOF
fi
sudo systemctl enable greetd

# ─── Services ────────────────────────────────────────────────
sudo systemctl enable power-profiles-daemon

msg "All done! Reboot and greetd/tuigreet will log you into Hyprland."
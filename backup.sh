#!/usr/bin/env bash
# Sync your current configs INTO the dotfiles repo, commit, and push.
# Rerun anytime you change something.
set -euo pipefail

DOTFILES_DIR="$HOME/Documents/GitHub/caelestia-shell-dotfiles/"

# Which ~/.config folders to track — edit this list
CONFIGS=(caelestia fish hypr)

# Track wallpapers too? (comment out to skip)
WALLPAPERS_DIR="$HOME/Pictures/Wallpapers"

mkdir -p "$DOTFILES_DIR/config"
for c in "${CONFIGS[@]}"; do
    if [[ -d $HOME/.config/$c ]]; then
        mkdir -p "$DOTFILES_DIR/config/$c"
        cp -rT "$HOME/.config/$c" "$DOTFILES_DIR/config/$c"
        echo "synced: $c"
    else
        echo "skipped (not found): $c"
    fi
done

if [[ -n ${WALLPAPERS_DIR:-} && -d $WALLPAPERS_DIR ]]; then
    mkdir -p "$DOTFILES_DIR/wallpapers"
    cp -rT "$WALLPAPERS_DIR" "$DOTFILES_DIR/wallpapers"
    echo "synced: wallpapers"
fi

# Package lists (reference only, bootstrap doesn't auto-install these)
pacman -Qqen > "$DOTFILES_DIR/pkglist-pacman.txt"
pacman -Qqem > "$DOTFILES_DIR/pkglist-aur.txt"

cd "$DOTFILES_DIR"
echo "Done — open GitHub Desktop to review and commit the changes."

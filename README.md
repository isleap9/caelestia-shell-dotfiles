# caelestia-shell-dotfiles

My personal Arch Linux setup: [Caelestia shell](https://github.com/caelestia-dots/shell) on Hyprland, plus my configs, packages and wallpapers.

`bootstrap.sh` takes a freshly installed minimal Arch system and turns it into my full desktop in one run.

---

## Install

### 1. Install minimal Arch

Boot the Arch ISO and run:

```bash
archinstall
```

Choose a **minimal** profile (no desktop environment) and make sure you enable **NetworkManager** so you have internet after reboot.

Reboot and log in as your normal user.

### 2. Get git

```bash
sudo pacman -Sy git
```

### 3. Clone this repo

```bash
mkdir -p ~/Documents/GitHub
git clone https://github.com/isleap9/caelestia-shell-dotfiles ~/Documents/GitHub/caelestia-shell-dotfiles
cd ~/Documents/GitHub/caelestia-shell-dotfiles
```

> The path matters — `bootstrap.sh` expects the repo at `~/Documents/GitHub/caelestia-shell-dotfiles`. If you clone somewhere else, edit `DOTFILES_DIR` at the top of the script.

### 4. Run the bootstrap

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

Run it as your **normal user**, not root. It will ask for your sudo password along the way.

### 5. Reboot

```bash
reboot
```

greetd/tuigreet will come up and log you straight into Hyprland with Caelestia.

---

## Before you run it — things to check

Open `bootstrap.sh` and look at the block marked `EDIT IF NEEDED` near the top.

**NVIDIA drivers.** The package list includes `nvidia-dkms`, `nvidia-utils`, `nvidia-settings` and `linux-headers`. Remove these from `EXTRA_PKGS` if the machine is AMD or Intel.

**`akari-tool`.** This is listed in `EXTRA_AUR_PKGS` but isn't published on the AUR yet. The script runs with `set -e`, so paru failing to find it will abort the run before greetd gets configured. Remove it from that line until it's actually published.

**Login manager.** The script enables greetd with tuigreet. If you'd rather use SDDM or start Hyprland manually, delete the greetd section and drop `greetd greetd-tuigreet` from `EXTRA_PKGS`.

---

## What the bootstrap actually does

In order:

1. Full system update (`pacman -Syu`)
2. Installs `base-devel`, `git`, `fish`
3. Builds **paru** from source if no AUR helper is present
4. Installs `caelestia-cli` and runs `caelestia install` (pulls in the shell and its extras)
5. Clones/pulls this repo, then copies everything in `config/` over the top of `~/.config/` — so my personal settings land *after* Caelestia's defaults
6. Copies `wallpapers/` to `~/Pictures/Wallpapers`
7. Installs the extra pacman + AUR packages
8. Writes `/etc/greetd/config.toml` and enables greetd
9. Enables `power-profiles-daemon` and the `arch-update` user timer

It's safe to re-run — every install uses `--needed`, and the repo is pulled rather than re-cloned.

---

## Saving changes back

After tweaking configs on a running system, pull them back into the repo:

```bash
cd ~/Documents/GitHub/caelestia-shell-dotfiles
./backup.sh
```

Then commit and push (via GitHub Desktop or plain git).

---

## Repo layout

| Path | What it is |
| --- | --- |
| `bootstrap.sh` | Fresh-install script — run this |
| `backup.sh` | Copies live configs back into the repo |
| `config/` | Contents get overlaid onto `~/.config/` |
| `wallpapers/` | Copied to `~/Pictures/Wallpapers` |
| `pkglist-pacman.txt` | Snapshot of installed repo packages (reference) |
| `pkglist-aur.txt` | Snapshot of installed AUR packages (reference) |

The package lists are snapshots for reference — `bootstrap.sh` installs from its own `EXTRA_PKGS` / `EXTRA_AUR_PKGS` variables, not from these files.

---

## Known quirks

- **Lyrics patch** — if you use the background lyrics patch, it lives outside the AUR package and has to be reapplied after every `caelestia-shell` update by copying the patched files into `/etc/xdg/quickshell/caelestia/modules/background/`.
- **Duplicate wallpaper folders** — the repo currently has both `Wallpapers/` and `wallpapers/`. Only the lowercase one is used by the script; the other should be removed (needs `git mv` with a temp name, since git on a case-insensitive checkout won't see the rename directly).
- **fish shell** — the scripts are bash and start with `#!/usr/bin/env bash`, so run them as `./bootstrap.sh`, not by sourcing them into fish.

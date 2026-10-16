#!/usr/bin/env bash
#
# restore.sh — put this machine's rice back in place.
# Safe to re-run. Existing real (non-symlink) files are moved aside, never deleted.
#
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
P="$HERE/payload"
STAMP="$(date +%s)"

info() { printf '\033[0;32m[*]\033[0m %s\n' "$*"; }

# 1. the ML4W config tree
if [ -d "$P/mydotfiles" ]; then
    info "Restoring ~/.mydotfiles ..."
    mkdir -p "$HOME/.mydotfiles"
    cp -a "$P/mydotfiles/." "$HOME/.mydotfiles/"
fi

# 2. extra ~/.config entries (real files)
if [ -d "$P/config" ]; then
    info "Restoring ~/.config entries ..."
    mkdir -p "$HOME/.config"
    cp -a "$P/config/." "$HOME/.config/"
fi

# 3. ~/.local/share assets (fonts, icons, apps)
if [ -d "$P/local-share" ]; then
    info "Restoring ~/.local/share assets ..."
    mkdir -p "$HOME/.local/share"
    cp -a "$P/local-share/." "$HOME/.local/share/"
fi

# 4. shell setup
if [ -d "$P/home" ]; then
    info "Restoring shell setup ..."
    cp -a "$P/home/." "$HOME/"
fi

# 5. recreate the symlinks (skip/backup anything in the way)
if [ -f "$HERE/symlinks.txt" ]; then
    info "Recreating symlinks ..."
    while IFS=$'\t' read -r link target; do
        [ -z "${link:-}" ] && continue
        dest="$HOME/$link"
        if [ -e "$dest" ] && [ ! -L "$dest" ]; then
            mv "$dest" "$dest.pre-rice-restore-$STAMP"
        fi
        mkdir -p "$(dirname "$dest")"
        ln -sfn "$target" "$dest"
    done < "$HERE/symlinks.txt"
fi

# 6. refresh caches
info "Refreshing font / icon caches ..."
command -v fc-cache >/dev/null 2>&1 && fc-cache -f >/dev/null 2>&1 || true
if [ -d "$HOME/.local/share/icons/kora" ] && command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -f "$HOME/.local/share/icons/kora" >/dev/null 2>&1 || true
fi

cat <<'NOTE'

[OK] Restore complete.

Next steps:
  * The base system must exist first: Hyprland, Quickshell (qs), waybar, rofi,
    kitty, swaync, awww, and the ML4W dotfiles. See packages/ for the list from
    the machine this backup came from.
  * Log out and back in (or run `hyprctl reload`) so Hyprland reloads everything.

NOTE

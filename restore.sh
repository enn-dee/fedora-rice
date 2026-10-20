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

# 3b. DMS runtime state (points at the wallpaper)
if [ -d "$P/local-state" ]; then
    info "Restoring ~/.local/state ..."
    mkdir -p "$HOME/.local/state"
    cp -a "$P/local-state/." "$HOME/.local/state/"
fi

# 3c. wallpaper, back to the absolute path DMS remembers
if [ -d "$P/wallpapers" ] && [ -f "$P/wallpapers/wallpaper-path.txt" ]; then
    WP="$(cat "$P/wallpapers/wallpaper-path.txt")"
    if [ -n "$WP" ]; then
        info "Restoring wallpaper: $WP"
        mkdir -p "$(dirname "$WP")"
        for f in "$P/wallpapers"/*; do
            [ "$(basename "$f")" = "wallpaper-path.txt" ] && continue
            cp -a "$f" "$(dirname "$WP")/"
        done
    fi
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
for theme in kora Bibata-Modern-Ice; do
    if [ -d "$HOME/.local/share/icons/$theme" ] && command -v gtk-update-icon-cache >/dev/null 2>&1; then
        gtk-update-icon-cache -f "$HOME/.local/share/icons/$theme" >/dev/null 2>&1 || true
    fi
done

cat <<'NOTE'

[OK] Restore complete.

Next steps:
  * The base system must exist first. Main session: niri, DankMaterialShell (dms),
    ghostty, matugen. Fallback session: Hyprland, Quickshell (qs), waybar, rofi,
    kitty, swaync, awww, and the ML4W dotfiles. See packages/ for the list from
    the machine this backup came from.
  * Log out and back in so niri / DMS (and Hyprland, if you use it) reload
    everything. Niri reloads config.kdl live; DMS reads settings.json on start.
  * If the wallpaper did not come back, point DMS at it again:
        dms ipc call wallpaper set <path>
  * DMS plugins are NOT in this archive (too large). Re-install them from the
    DMS plugin manager; plugins.lock.json lists what was installed.

NOTE

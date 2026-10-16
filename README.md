# 🍚 ML4W Hyprland Rice — *island status bar*

A **portable, single-file Hyprland rice** for a fresh Linux install.
Built on top of [ML4W Dotfiles](https://ml4w.com/os/), with a custom
**island-style Quickshell status bar** in the spirit of
[kovasko/hyprland-dotfiles](https://github.com/kovasko/hyprland-dotfiles).

![status bar](screenshots/bar.png)

<p align="center">
  <img src="screenshots/power-menu.png" width="400" alt="session menu">
</p>

Everything lives in **one archive** (`fedora-rice.tar.gz`, ≈ 82 MiB) plus a
`restore.sh` that puts it back. Restoring is idempotent and never deletes
your files.

> **Built and tested on:** Fedora · Hyprland **0.56.2** · Quickshell **0.3.2** ·
> session started via `uwsm` · locale `en_US.UTF-8` · single 1920×1080 display.

---

## ✨ What this rice changes

| Feature | Detail |
|---|---|
| **Custom status bar** | Quickshell, island style, runs as its own `qs -p` instance. The stock ML4W bar is **disabled** (and easily re-enabled). |
| **5 workspaces** | Occupied workspaces show their number; the **active one is a glowing dot** instead of an underline. |
| **App icons** | Icons of every open app appear to the right of the workspaces (replaces the plain window-title text). |
| **12-hour clock** | `Friday 16 October - 11:29 PM` |
| **English UI** | Session / network / Bluetooth pop-ups fully translated (upstream was French). |
| **`Esc` closes any bar menu** | Real keyboard focus via Wayland layer-shell *exclusive* keyboard mode + `Shortcut` — not a fake focus flag. |
| **Working session menu** | Every button works: lock · suspend · logout · reboot · shutdown. |
| **AZERTY-aware keybinds** | Workspace number keys auto re-map on French / Belgian layouts (no manual editing). |
| **JetBrainsMono Nerd Font** | Bundled inside the archive and installed by `restore.sh`. |
| **kora icon theme** | Bundled inside the archive. |

**Bar layout, left → right:**

```
[ 1 2 3 4 5  🖥 🍎 🐍 🗂 ]   …   [ CPU  RAM  DISK  BAT ]  [ VOL ]  [ NET  BT ]  [ Friday 16 October - 11:29 PM ]  [ ⏻ ]
   workspaces + app icons                              metrics      volume     network     clock                          power
```

---

## 📋 Requirements

- A **fresh install** of a distro supported by ML4W (Fedora, Arch, openSUSE, …).
- The **base system must already exist** — this archive contains *configuration*,
  **not packages**.
- ≈ 2 GB free disk space (≈ 500 MB for the payload itself).
- An internet connection (for the ML4W installer and the few extra tools).

---

## 🚀 Installation

### Step 1 — Install the ML4W base system first

Follow the official ML4W instructions → **https://ml4w.com/os/**

```bash
# Stable release
bash <(curl -s https://ml4w.com/os/stable)

# …or the rolling release
bash <(curl -s https://ml4w.com/os/rolling)
```

Log in once afterwards so ML4W finishes creating `~/.mydotfiles`, the
`~/.config/*` symlinks and the packages. Then **reboot** (or log out/in).

> The ML4W installer brings in Hyprland, Quickshell, waybar, kitty, swaync,
> awww, hypridle, hyprshutdown, rofi/walker, the portals, etc. If you already
> have an equivalent setup, you can skip the installer — just make sure the
> commands used in the keybinds below exist.

### Step 2 — Get this rice

```bash
git clone https://github.com/enn-dee/fedora-rice.git
cd fedora-rice
```

*(Or simply download `fedora-rice.tar.gz` + `restore.sh` by hand — that is all you need.)*

### Step 3 — Restore

```bash
tar -xzf fedora-rice.tar.gz      # extracts  fedora-rice-YYYY-MM-DD/
cd fedora-rice-*/
./restore.sh
```

`restore.sh` is **safe to re-run**. If a real (non-symlink) file is already in
the way, it is moved to `*.pre-rice-restore-<timestamp>` — never deleted.

What it does, in order:

1. `payload/mydotfiles/` → `~/.mydotfiles` (the whole ML4W config tree + wallpapers)
2. `payload/config/` → `~/.config` (extra configs owned by this rice)
3. `payload/local-share/` → `~/.local/share` (JetBrainsMono Nerd Font, kora icons, ML4W apps)
4. `payload/home/` → `~` (`.oh-my-zsh`, `.zsh`)
5. Recreates the 28 `~/.config/*` + `~/.*` symlinks recorded in `symlinks.txt`
6. Refreshes the font and icon caches

### Step 4 — Install the few tools that are *not* bundled

The archive intentionally ships **no binaries** (that is what keeps it a single
portable file). Install these yourself:

```bash
# ── oh-my-posh — the shell prompt used by ~/.config/zshrc/20-customization
#    https://ohmyposh.dev/docs/installation/linux

# ── walker + elephant — the ML4W application launcher
#    https://github.com/abenz1267/walker
#    https://github.com/abenz1267/elephant

# ── the oh-my-zsh plugins referenced by the zsh config
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
```

**Optional — mouse cursor.** The config points at **`Bibata-Modern-Ice`**, which
is *not* bundled:

```bash
# https://github.com/ful1e5/Bibata_Cursor  → extract to ~/.local/share/icons/
# (or install your distro's Bibata package)
```

If you skip it, the system simply falls back to your distro's default cursor.
To use a different one, change the name in
`~/.config/hypr/conf/ml4w.lua` (`XCURSOR_THEME`) and
`~/.config/hypr/conf/autostart.lua` (`hyprctl setcursor …`).

### Step 5 — Log out and back in

```bash
hyprctl reload        # quick-ish…  but a full re-login is cleaner
```

The status bar starts automatically from
`~/.config/ml4w/scripts/ml4w-autostart`.

---

## ⌨️ Keybindings

Main modifier = **`SUPER`** (the Windows key).
On an **AZERTY** layout the workspace digits are re-mapped automatically
(`SUPER` + `&` = workspace 1, etc.).

### Apps & launchers

| Key | Action |
|---|---|
| `SUPER` `RETURN` | Terminal (kitty) |
| `SUPER` `B` | Browser |
| `SUPER` `E` | File manager |
| `SUPER` `C` | VS Code |
| `SUPER` `SPACE` / `SUPER` `CTRL` `RETURN` | Application launcher |
| `SUPER` `CTRL` `E` | Emoji picker |
| `SUPER` `TAB` | Window overview / select window |

### Workspaces

| Key | Action |
|---|---|
| `SUPER` `1` … `5` | Switch to workspace 1–5 |
| `SUPER` `SHIFT` `1` … `5` | Move the active window there |
| `SUPER` `mouse scroll` | Next / previous workspace |
| `SUPER` `S` | Toggle the scratchpad |
| `SUPER` `SHIFT` `S` | Move window to the scratchpad |

### Windows

| Key | Action |
|---|---|
| `SUPER` `Q` | Close active window |
| `SUPER` `SHIFT` `Q` | Close it **and** all its instances |
| `SUPER` `F` / `SUPER` `M` | Fullscreen / maximize |
| `SUPER` `T` | Toggle floating |
| `SUPER` `ALT` `T` | Toggle floating **+ pinned** |
| `SUPER` `H` | Minimize (to a special workspace) |
| `SUPER` `CTRL` `H` | Restore minimized windows |
| `SUPER` `G` | Toggle window group |
| `SUPER` `J` / `SUPER` `K` | Toggle split / swap split |
| `SUPER` `←↑↓→` | Move focus |
| `SUPER` `ALT` `←↑↓→` | Swap window |
| `SUPER` `SHIFT` `←↑↓→` | Resize window |
| `SUPER` `mouse drag` / `SUPER` right-drag | Move / resize with the mouse |

### System & utilities

| Key | Action |
|---|---|
| `SUPER` `PRINT` | Screenshot (interactive) |
| `SUPER` `ALT` `F` | Instant full-screen screenshot |
| `SUPER` `ALT` `S` | Instant area screenshot |
| `SUPER` `ALT` `A` | Extract text from a screen area (OCR) |
| `SUPER` `V` | Clipboard history |
| `SUPER` `CTRL` `L` | Lock screen |
| `SUPER` `CTRL` `P` | ML4W power menu |
| `SUPER` `SHIFT` `M` | Toggle light / dark |
| `SUPER` `SHIFT` `W` | Random wallpaper |
| `SUPER` `CTRL` `W` | Wallpaper picker |
| `CTRL` `ALT` `T` | Theme switcher |
| `SUPER` `CTRL` `K` | Show the keybinding cheatsheet |
| `SUPER` `SHIFT` `R` | Reload the Hyprland config |

### Media & hardware keys

Volume, mute, mic-mute, brightness and media playback (`XF86…`) work out of the
box (`wpctl`, `brightnessctl`, `playerctl`).

---

## 🎨 Customising

### The status bar

It lives in **`~/.config/quickshell/kovasko-statusbar/`**:

| File | What to change |
|---|---|
| `shell.qml` | The overall layout — left island (workspaces + app icons), then metrics, volume, network+Bluetooth, clock, power |
| `Theme.qml` | Every colour, radius and font size |
| `modules/Workspaces.qml` | Workspace count (`model: 5`) and the active-workspace **dot** |
| `modules/AppIcons.qml` | The row of icons for open apps |
| `modules/Clock.qml` | Clock format (`dddd dd MMMM - hh:mm AP`) |
| `modules/Cpu.qml`, `Memory.qml`, `Disk.qml`, `Battery.qml` | The individual meters |
| `modules/Volume.qml`, `Network.qml`, `Bluetooth.qml` | The right-hand indicators |
| `menu/PowerMenu.qml`, `NetworkMenu.qml`, `BluetoothMenu.qml` | The pop-up panels |

**Reload the bar** after editing it (this matches only the real `qs` process, so
it is safe to paste into your shell):

```bash
ps -eo pid,comm,args --no-headers \
  | awk '$2=="qs" && /kovasko-statusbar/ {print $1}' | xargs -r kill
setsid qs -p "$HOME/.config/quickshell/kovasko-statusbar" >/dev/null 2>&1 &
```

### Changing the workspace count

1. `~/.config/quickshell/kovasko-statusbar/modules/Workspaces.qml` → `model: 5`
2. `~/.config/ml4w-statusbar/config.json` → same number (only matters if you
   re-enable the ML4W bar)

### Bring back the stock ML4W status bar

```bash
# 1. switch the ML4W bar back on
#    ~/.config/ml4w-statusbar/config.json   →   "enabled": true

# 2. comment out the kovasko autostart in
#    ~/.config/ml4w/scripts/ml4w-autostart   (the `qs -p …/kovasko-statusbar` block)
```

Then log out and back in. Nothing else needs to change.

---

## 📦 What's inside the archive

```
fedora-rice-YYYY-MM-DD/
├── README.md          ← short version of this file
├── restore.sh         ← the restore script (safe to re-run)
├── rice-backup.sh     ← the generator, so you can re-snapshot later
├── MANIFEST.txt       ← every single file in the archive
├── symlinks.txt       ← the 28 ~/.config/* + ~/.* symlinks to recreate
├── packages/          ← package list from the source machine
└── payload/
    ├── mydotfiles/    → ~/.mydotfiles      (all ML4W configs + wallpapers)
    ├── config/        → ~/.config          (ml4w-statusbar, ml4w-dock, ml4w-powermenu,
    │                                        ghostty, cava, htop, nwg-look, nwg-displays,
    │                                        dconf, systemd, mimeapps.list, …)
    ├── local-share/   → ~/.local/share     (JetBrainsMono Nerd Font, kora icons,
    │                                        quickshell-overview, ml4w-dock,
    │                                        ml4w-powermenu, ml4w-walker, …)
    └── home/          → ~                 (.oh-my-zsh, .zsh)
```

| Path in archive | Restores to | Contents |
|---|---|---|
| `payload/mydotfiles/` | `~/.mydotfiles` | The full ML4W config tree — hypr, quickshell (incl. the custom bar), waybar, rofi, kitty, swaync, walker, zsh, ohmyposh, matugen, wallpapers |
| `payload/config/` | `~/.config` | Configs owned by this rice that are *not* symlinks into `~/.mydotfiles` |
| `payload/local-share/` | `~/.local/share` | Fonts, icon theme, ML4W Quickshell apps |
| `payload/home/` | `~` | `.oh-my-zsh`, `.zsh` |
| `symlinks.txt` | — | Recreates the `~/.config/*` + `~/.*` symlinks into `~/.mydotfiles` |
| `packages/` | — | Reference package lists (`dnf`, `pacman`, `apt`, flatpak) |
| `rice-backup.sh` | — | Re-run it to produce a fresh snapshot |

> **Not included on purpose:** binaries (`~/.local/bin/*`) and the shell
> history. That keeps the archive portable — and under GitHub's per-file limit.

---

## 🔁 Updating the backup

```bash
~/.local/bin/rice-backup                      # → ~/fedora-rice-YYYY-MM-DD.tar.gz
cp ~/fedora-rice-$(date +%F).tar.gz fedora-rice.tar.gz
git add -A && git commit -m "refresh rice snapshot" && git push
```

---

## 🩺 Troubleshooting

**The bar is missing**

```bash
pgrep -a qs        # you should see TWO processes:
                   #   qs                                    (ML4W theme manager)
                   #   qs -p /home/<you>/.config/quickshell/kovasko-statusbar
qs -p ~/.config/quickshell/kovasko-statusbar    # run it in the foreground to see QML errors
```

**Hyprland complains about the config**

```bash
hyprctl configerrors
cat ~/.config/quickshell/kovasko-statusbar/*.qml   # check imports if the bar won't start
```

**The status bar covers my windows / windows hide under it**
The bar is a Wayland *layer-shell* panel, so it reserves its own space
(30 px + 5 px margin = 35 px) automatically. If the stock ML4W bar is also
enabled you will get two bars — disable one of them (see *Customising*).

**My keybindings don't work**
Press `SUPER` `CTRL` `K` for the cheatsheet, and `SUPER` `SHIFT` `R` to reload.
Check `~/.config/hypr/conf/keybindings/default.lua` — the workspace keys are
computed at load time from `~/.config/hypr/input.lua`, so an unusual layout +
variant might need a nudge.

**The zsh prompt looks broken**
`oh-my-posh` is not bundled — install it (see *Step 4*).

**`[oh-my-zsh] plugin '…' not found`**
Clone the three plugins listed in *Step 4*.

**The cursor is the wrong shape / theme**
The config references `Bibata-Modern-Ice`; install it or change the name
(see *Step 4*).

---

## 🙏 Credits

- **[ML4W Dotfiles](https://github.com/mylinuxforwork/dotfiles)** by Stephan Raabe —
  the entire base system (GPL-3.0).
- **[kovasko/hyprland-dotfiles](https://github.com/kovasko/hyprland-dotfiles)** —
  the status bar this one is modelled on. *That repository declares no license —
  if you plan to redistribute the bar itself, ask its author first.*
- **[JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts)** (SIL OFL 1.1).
- **kora** icon theme.
- **[oh-my-posh](https://ohmyposh.dev)** — the `zen` theme for the shell prompt.

## 📄 License

This repository is a **personal configuration snapshot**, shared as-is for
anyone who wants to reproduce the look.

- The **ML4W parts** remain under **GPL-3.0** — see upstream.
- The **status bar** derives from kovasko's work, which carries **no declared
  license**.
- Everything written specifically for this rice may be used freely for personal
  setups.

Please keep the credits above if you fork this.

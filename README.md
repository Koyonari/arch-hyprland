# MY HYPRLAND RICE

This rice uses configs from many repos, so it's not 100% pure my creation.

I use **Matugen** as the color scheme generator — the entire color scheme (Hyprland borders, Waybar, Kitty, Rofi, Cava, GTK, Discord, Spotify) updates automatically when you pick a wallpaper. `Super+Shift+W` opens **Waypaper** (backed by `awww`), which sets the wallpaper and runs Matugen automatically via a post-command hook.

Special credit to [JaKooLit](https://github.com/JaKooLit) — several scripts and Waybar configs are adapted from his dotfiles.

<img width="1920" height="1080" alt="20250720_22h08m02s_grim" src="https://github.com/user-attachments/assets/cdfc60a8-9241-4633-bc23-8d80ebe9f862" />

<img width="1920" height="1080" alt="20250720_22h10m55s_grim" src="https://github.com/user-attachments/assets/66696b8b-d479-4884-b10b-1920ae8b21a2" />

---

## What's included

| Component | Program |
|---|---|
| Window Manager | Hyprland |
| Bar | Waybar (multiple layouts + styles, switchable via `Super+Ctrl+B` / `Super+Alt+B`) |
| Terminal | Kitty |
| App Launcher | Rofi (Wayland) |
| Notifications | SwayNC (swaync) |
| Lock Screen | Hyprlock |
| Idle Daemon | Hypridle |
| Wallpaper | Waypaper (backend: awww) |
| Color Scheme | Matugen |
| Shell | Zsh + Oh My Zsh |
| File Manager | Nautilus / Yazi |
| Audio Visualizer | Cava |
| Logout Menu | Wlogout |

---

## Installation (CachyOS / Arch Linux)

### Prerequisites — dual boot setup (read before installing Linux)

> Skip this section if you're doing a single-boot install.

1. **Install Windows first** (if not already done) — Windows overwrites the bootloader, so always install it before Linux.
2. **Disable Fast Startup in Windows** — this leaves the NTFS filesystem in a hibernated state that Linux can't safely mount.
   - Control Panel → Power Options → "Choose what the power buttons do" → uncheck "Turn on fast startup"
3. **Disable BitLocker** (or save your recovery key) — resizing Windows partitions from the Linux installer may trigger a BitLocker recovery prompt.
4. **Disable Secure Boot in BIOS** (or use CachyOS MOK enrollment if you want it on).
5. Leave unallocated space for Linux — CachyOS installer will use it.

### Install CachyOS

Select the **Hyprland** desktop variant in the CachyOS installer if you want it pre-configured (you'll replace the configs after). Any variant works.

During partitioning, use **GRUB** as the bootloader — it picks up Windows automatically.

### Deploy these dotfiles

```bash
# Clone the repo
git clone https://github.com/<your-username>/arch-hyprland.git
cd arch-hyprland

# Run the installer (installs all packages + copies configs)
bash install.sh
```

The installer will:
- Install all required packages via `pacman`
- Copy configs to `~/.config/`
- Copy wallpapers to `~/Pictures/wallpapers/`
- Set up initial Waybar symlinks
- Set zsh as default shell
- Enable PipeWire services

### After first boot into CachyOS

**Detect Windows in GRUB:**
```bash
sudo os-prober
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

**Fix the clock** (Windows uses local time, Linux uses UTC — this causes a 8-hour offset):
```bash
timedatectl set-local-rtc 1
```

**Initialize your color scheme** — open a terminal and pick a wallpaper:
```bash
# Super+W opens the wallpaper picker and runs matugen automatically
# Or manually:
matugen image ~/Pictures/wallpapers/<wallpaper-file>
```

---

## Manual package list

If you prefer to install packages yourself instead of using `install.sh`:

All packages below are available in the official CachyOS/Arch repos — no AUR helper needed.

**pacman:**
```
hyprland waybar hypridle hyprlock hyprpolkitagent hyprpicker
xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
kitty zsh zsh-autosuggestions zsh-syntax-highlighting
awww waypaper grim slurp playerctl brightnessctl pamixer
pipewire pipewire-pulse pipewire-alsa wireplumber
networkmanager network-manager-applet blueman
rofi matugen swaync wlogout
nautilus yazi fastfetch cava
ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji cantarell-fonts
qt5-wayland qt6-wayland libnotify polkit-kde-agent gtk3 gtk4 python
```

**Optional:**
```
vesktop  (Discord)
```

---

## Keybinds

Defined in `.config/hypr/config/keybinds.lua` (Hyprland's native Lua config — this is
what's actually loaded; see [Notes](#notes)).

**Apps / launchers**

| Key | Action |
|---|---|
| `Super + Return` | Kitty (tiled) |
| `Super + Shift + Return` | Kitty (floating) |
| `Super + T` | Text editor |
| `Super + E` | Nautilus |
| `Super + Shift + E` | Yazi (terminal file manager) |
| `Super + W` | Open default browser (zen) |
| `Super + Space` / `Super + Shift + D` | Rofi app launcher |
| `Super + I` | GNOME settings (Control Center) |
| `Super + Shift + W` | Waypaper (wallpaper picker + matugen recolor) |
| `Ctrl + Shift + Escape` | Kitty + btop |

**Window management**

| Key | Action |
|---|---|
| `Super + Q` | Close window |
| `Super + Shift + Q` | Kill process (force) |
| `Super + D` | Fullscreen (maximize) |
| `Super + Shift + F` | Fullscreen (toggle) |
| `Super + Alt + Space` / `Super + Shift + Space` | Toggle floating |
| `Super + J` | Toggle split (dwindle) |
| `Super + Escape` | Kill active window (via `hyprctl kill`) |
| `Super + Left/Right/Up/Down` | Move focus |
| `Super + Shift + Left/Right/Up/Down` | Move window around workspace |
| `Super + Alt + Left/Right/Up/Down` | Resize active window |
| `Super + Ctrl + Shift + Left/Right` | Move window to adjacent workspace |
| `Super + [mouse LMB]` / `Super + [mouse RMB]` | Drag / resize window |

**Workspaces**

| Key | Action |
|---|---|
| `Super + 0-9` | Switch to workspace |
| `Super + Shift + 0-9` | Move window to workspace (and follow) |
| `Super + Alt + 0-9` | Move window to workspace (stay) |
| `Super + Ctrl + Left/Right` | Switch to adjacent workspace |
| `Super + Ctrl + Down` | Switch to next empty workspace |
| `Super + Ctrl + Alt + Left/Right` | Move window to adjacent workspace |
| `Super + [scroll]` | Cycle through existing workspaces |

**Utilities**

| Key | Action |
|---|---|
| `Super + L` | Lock screen |
| `Super + P` | Color picker (hyprpicker) |
| `Super + Shift + P` | Screenshot (area select → `~/Pictures/Screenshots/`) |
| `Super + Shift + C` | Color picker (hyprpicker, dotfiles duplicate) |
| `Print` | Screenshot → clipboard (`grim | wl-copy`) |
| `Super + Z` / `Super + A` | Toggle notification center (swaync) |
| `Super + Alt + C` / `Super + X` | Logout menu (wlogout) |
| `Ctrl + Alt + Delete` | Exit Hyprland |

**Waybar**

| Key | Action |
|---|---|
| `Super + H` | Hide/show Waybar |
| `Super + Shift + R` | Restart Waybar |
| `Super + Ctrl + B` | Waybar style picker |
| `Super + Alt + B` | Waybar layout picker |

**Hardware keys** — volume, mic mute, brightness, and media keys (`XF86Audio*`, `XF86MonBrightness*`) are bound to the scripts in `scripts/`.

> `Super + C` (calculator) and the scratchpad binds (`Super + S` / `Super + Shift + S`) that ship with CachyOS's default config have been removed on this machine — see [Notes](#notes).

---

## Notes

- **Lua config** — Hyprland is configured via `.config/hypr/hyprland.lua` + `.config/hypr/config/*.lua` (Hyprland's native Lua config, as shipped by CachyOS). When both a `hyprland.lua` and a `hyprland.conf` exist in `~/.config/hypr/`, Hyprland loads the Lua one — a plain `.conf` main config isn't used here. Everything under `configs/*.conf` (the old `.conf`-based bind/animation/rules setup this rice used pre-CachyOS) has been removed since it was dead weight: none of it was actually loaded.
- **Keybinds** live in `config/keybinds.lua`. It has two parts: CachyOS's own defaults (window management, launchers, hardware keys, workspaces) followed by a `DOTFILES CUSTOM BINDS` section with everything this rice adds on top, on modifier combos that don't collide with the defaults (e.g. screenshot is `Super+Shift+P`, not `Super+Shift+S`, because `Super+Shift+S` is a CachyOS default). `Super + C` (calculator) and the CachyOS scratchpad binds (`Super + S` / `Super + Shift + S`) were deliberately deleted from `config/keybinds.lua` rather than worked around, freeing `Super + C` and `Super + S` entirely (currently unbound).
- **Monitor config** — `config/monitors.lua` auto-detects (`mode = "preferred"`, `scale = "auto"`). Run `hyprctl monitors` to see what's connected if you need to pin a specific mode.
- **Waybar** uses symlinks: `~/.config/waybar/config` and `~/.config/waybar/style.css` point to files in `configs/` and `style/`. Use the `Super+Ctrl+B` / `Super+Alt+B` menus to switch, or re-run the symlink manually.
- **Matugen** regenerates all color files (`hyprland`, `kitty`, `waybar`, `rofi`, `cava`, `gtk-3.0`, `gtk-4.0`, `vesktop`, `spicetify`) from one wallpaper image, triggered by Waypaper's post-command hook when you pick a wallpaper (`Super+Shift+W`). The Hyprland color template's post-hook runs `scripts/apply-colors.sh`, which re-applies the new border colors live via `hyprctl eval`.
- **Wallpapers** are loaded from `~/Pictures/wallpapers/`. The `install.sh` copies the included wallpapers there.
- **hyprlock** background uses `~/.config/hypr/current_wallpaper` (a symlink Waypaper's post-command hook updates on every wallpaper change).

# MY HYPRLAND RICE

This rice uses configs from many repos, so it's not 100% pure my creation.

I use **Matugen** as the color scheme generator — the entire color scheme (Hyprland borders, Waybar, Kitty, Rofi, Cava, GTK, Discord, Spotify) updates automatically when you pick a wallpaper. The wallpaper picker script (`Super+W`) runs `swww` + Matugen together.

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
| Wallpaper | swww |
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
- Install all required packages via `pacman` and `paru`
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

**pacman:**
```
hyprland waybar hypridle hyprlock hyprpolkitagent
xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
kitty zsh zsh-autosuggestions zsh-syntax-highlighting
swww grim slurp playerctl brightnessctl pamixer
pipewire pipewire-pulse pipewire-alsa wireplumber
networkmanager network-manager-applet blueman
nautilus yazi fastfetch cava
ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji cantarell-fonts
qt5-wayland qt6-wayland libnotify polkit-kde-agent gtk3 gtk4
```

**AUR (paru):**
```
rofi-wayland matugen swaync wlogout hyprpicker
vesktop spicetify-cli  (optional)
```

---

## Keybinds

| Key | Action |
|---|---|
| `Super + Return` | Kitty (tiled) |
| `Super + Shift + Return` | Kitty (floating) |
| `Super + D` | Rofi app launcher |
| `Super + Q` | Close window |
| `Super + Shift + Q` | Kill process (force) |
| `Super + W` | Wallpaper picker (+ matugen recolor) |
| `Super + L` | Lock screen |
| `Super + E` | Nautilus |
| `Super + Shift + E` | Yazi (terminal file manager) |
| `Super + B` | Open default browser |
| `Super + Space` | Toggle floating |
| `Super + Shift + F` | Fullscreen |
| `Super + Shift + S` | Screenshot (area select → `~/Pictures/Screenshots/`) |
| `Super + C` | Color picker (hyprpicker) |
| `Super + H` | Hide/show Waybar |
| `Super + R` | Restart Waybar |
| `Super + Ctrl + B` | Waybar style picker |
| `Super + Alt + B` | Waybar layout picker |
| `Ctrl + Alt + Delete` | Exit Hyprland |

---

## Notes

- **Monitor config** — `hyprland.conf` is set to `eDP-1, 1920x1080@60` (laptop internal display). Change this if your monitor name or resolution differs. Run `hyprctl monitors` to see available monitors.
- **Waybar** uses symlinks: `~/.config/waybar/config` and `~/.config/waybar/style.css` point to files in `configs/` and `style/`. Use the `Super+Ctrl+B` / `Super+Alt+B` menus to switch, or re-run the symlink manually.
- **Matugen** regenerates all color files (`hyprland`, `kitty`, `waybar`, `rofi`, `cava`, `gtk-3.0`, `gtk-4.0`, `vesktop`, `spicetify`) from one wallpaper image. The wallpaper picker (`Super+W`) handles this automatically.
- **Wallpapers** are loaded from `~/Pictures/wallpapers/`. The `install.sh` copies the included wallpapers there.
- **hyprlock** background uses `~/.config/hypr/current_wallpaper` (a symlink created by the wallpaper picker).

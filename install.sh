#!/bin/bash
# Hyprland dotfiles installer — CachyOS / Arch Linux
# Run from the repo root: bash install.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
log()  { echo -e "${GREEN}[+]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[x]${NC} $1"; exit 1; }

# --- AUR helper ---
if command -v paru &>/dev/null; then
    AUR=paru
elif command -v yay &>/dev/null; then
    AUR=yay
else
    err "No AUR helper found. Install paru or yay first:\n  sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/paru.git /tmp/paru && cd /tmp/paru && makepkg -si"
fi
log "Using $AUR"

# --- Packages ---
PACMAN_PKGS=(
    # Hyprland ecosystem
    hyprland waybar hypridle hyprlock hyprpolkitagent
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
    # Terminal / shell
    kitty zsh zsh-autosuggestions zsh-syntax-highlighting
    # Wayland utilities
    swww grim slurp playerctl brightnessctl pamixer
    # Audio
    pipewire pipewire-pulse pipewire-alsa wireplumber
    # Networking / BT
    networkmanager network-manager-applet blueman
    # Apps
    nautilus yazi fastfetch cava
    # Fonts
    ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji cantarell-fonts
    # Qt Wayland support
    qt5-wayland qt6-wayland
    # Misc
    libnotify polkit-kde-agent gtk3 gtk4 python
)

AUR_PKGS=(
    rofi-wayland
    matugen
    swaync
    wlogout
    hyprpicker
)

OPTIONAL_PKGS=(
    vesktop        # Discord
    spicetify-cli  # Spotify theming
)

log "Installing official packages..."
sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"

log "Installing AUR packages..."
$AUR -S --needed --noconfirm "${AUR_PKGS[@]}"

echo ""
warn "Optional: vesktop (Discord), spicetify-cli (Spotify themes)"
read -rp "Install optional packages? [y/N] " opt
if [[ "$opt" =~ ^[Yy]$ ]]; then
    $AUR -S --needed --noconfirm "${OPTIONAL_PKGS[@]}"
fi

# --- Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- Deploy configs ---
log "Copying configs to ~/.config/ ..."
# Exclude the 'swaync 0.12' backup folder — scripts use 'swaync' (no version)
rsync -av --exclude='swaync 0.12' --exclude='.git' \
    "$DOTFILES_DIR/.config/" "$HOME/.config/"

# zshrc
cp "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
log "Copied .zshrc"

# --- Wallpapers ---
log "Copying wallpapers to ~/Pictures/wallpapers/ ..."
mkdir -p "$HOME/Pictures/wallpapers"
cp -n "$DOTFILES_DIR/wallpapers/"* "$HOME/Pictures/wallpapers/" 2>/dev/null || true

# --- Waybar symlinks (initial setup) ---
log "Setting up initial Waybar config and style symlinks..."
WAYBAR_CONFIGS="$HOME/.config/waybar/configs"
WAYBAR_STYLES="$HOME/.config/waybar/style"

DEFAULT_LAYOUT="bintang default"
DEFAULT_STYLE="bintang default"

if [ -f "$WAYBAR_CONFIGS/$DEFAULT_LAYOUT" ]; then
    ln -sf "$WAYBAR_CONFIGS/$DEFAULT_LAYOUT" "$HOME/.config/waybar/config"
else
    # Fall back to whatever is there
    ln -sf "$WAYBAR_CONFIGS/$(ls "$WAYBAR_CONFIGS" | head -1)" "$HOME/.config/waybar/config"
fi

if [ -f "$WAYBAR_STYLES/$DEFAULT_STYLE.css" ]; then
    ln -sf "$WAYBAR_STYLES/$DEFAULT_STYLE.css" "$HOME/.config/waybar/style.css"
else
    ln -sf "$(ls "$WAYBAR_STYLES"/*.css | head -1)" "$HOME/.config/waybar/style.css"
fi

# --- GTK color import (matugen outputs here) ---
for ver in gtk-3.0 gtk-4.0; do
    mkdir -p "$HOME/.config/$ver"
    GTK_CSS="$HOME/.config/$ver/gtk.css"
    if [ ! -f "$GTK_CSS" ] || ! grep -q 'colors.css' "$GTK_CSS" 2>/dev/null; then
        echo '@import "colors.css";' >> "$GTK_CSS"
        log "Added matugen import to $GTK_CSS"
    fi
done

# --- Make scripts executable ---
log "Making Hyprland scripts executable..."
chmod +x "$HOME/.config/hypr/scripts/"*.sh

# --- Default shell ---
if [ "$SHELL" != "$(which zsh)" ]; then
    log "Setting zsh as default shell (you'll need to log out)..."
    chsh -s "$(which zsh)"
fi

# --- User services ---
log "Enabling PipeWire user services..."
systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || true

# --- Pick an initial wallpaper to seed matugen colors ---
FIRST_WALL=$(ls "$HOME/Pictures/wallpapers/"*.{jpg,png,gif,jpeg} 2>/dev/null | head -1)
if [ -n "$FIRST_WALL" ]; then
    log "Seeding matugen colors from: $(basename "$FIRST_WALL")"
    warn "swww-daemon must be running for this — skip if setting up before first login."
    read -rp "Seed colors now? Requires swww-daemon running. [y/N] " seed
    if [[ "$seed" =~ ^[Yy]$ ]]; then
        swww-daemon &
        sleep 1
        matugen image "$FIRST_WALL"
    fi
fi

echo ""
log "Install complete!"
echo ""
warn "NEXT STEPS:"
echo "  1. Log out and select Hyprland from your display manager (or run: exec Hyprland)"
echo "  2. Press Super+W to open the wallpaper picker and let matugen generate your color scheme"
echo ""
warn "DUAL BOOT (run these in a terminal after first boot into CachyOS):"
echo "  sudo os-prober"
echo "  sudo grub-mkconfig -o /boot/grub/grub.cfg"
echo "  timedatectl set-local-rtc 1  # sync clock with Windows"

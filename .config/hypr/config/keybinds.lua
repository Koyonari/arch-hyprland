local mainMod = "SUPER"
local launchPrefix = "uwsm app -- " -- if you are not using UWSM, make this empty (e.g. "")

---------------------------
---- WINDOW MANAGEMENT ----
---------------------------

hl.bind(mainMod .. " + Escape",      hl.dsp.exec_cmd("hyprctl kill"))
hl.bind(mainMod .. " + Q",           hl.dsp.window.close())
hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D",           hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + J",           hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + L",           hl.dsp.exec_cmd("~/.config/hypr/scripts/hyprlock.sh"))
hl.bind(mainMod .. " + ALT + C",     hl.dsp.exec_cmd("wlogout"))

-- Change focus
hl.bind(mainMod .. " + Left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + Up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + Down",  hl.dsp.focus({ direction = "down" }))
hl.bind("ALT + Tab",           hl.dsp.window.cycle_next())

-- Move active window around current workspace
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + Left",  hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + Up",    hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + Down",  hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + Right", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + Left",  hl.dsp.window.move({ workspace = "r-1" }))

-- Move & Resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

------------------
---- LAUNCHER ----
------------------

hl.bind(mainMod .. " + Return",     hl.dsp.exec_cmd(launchPrefix .. TERMINAL))
hl.bind(mainMod .. " + E",          hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER))
hl.bind(mainMod .. " + T",          hl.dsp.exec_cmd(launchPrefix .. EDITOR))
hl.bind(mainMod .. " + W",          hl.dsp.exec_cmd(launchPrefix .. BROWSER))
hl.bind("CONTROL + SHIFT + Escape", hl.dsp.exec_cmd(launchPrefix .. TERMINAL .. " -e btop"))
hl.bind(mainMod .. " + Z",          hl.dsp.exec_cmd("swaync-client -t"))
hl.bind(mainMod .. " + X",          hl.dsp.exec_cmd("wlogout"))
hl.bind(mainMod .. " + Space",      hl.dsp.exec_cmd("rofi -show drun"))

---------------------------
---- HARDWARE CONTROLS ----
---------------------------

-- Audio
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --inc"),    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --dec"),    { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

-- Media
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness.sh --inc"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness.sh --dec"), { repeating = true })

-------------------
---- UTILITIES ----
-------------------

-- Screen Capture
hl.bind(mainMod .. " + P",     hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind("Print",               hl.dsp.exec_cmd("grim - | wl-copy"))

-- Theming and Wallpaper
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("waypaper"))

-- Clipboard

-------------------------------
---- DOTFILES CUSTOM BINDS ----
-------------------------------

-- App launchers
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("[float; size 800 550] kitty"))
hl.bind(mainMod .. " + SHIFT + D",      hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + SHIFT + E",      hl.dsp.exec_cmd("kitty yazi"))
hl.bind(mainMod .. " + B",              hl.dsp.exec_cmd("flatpak run app.zen_browser.zen"))
hl.bind(mainMod .. " + I",              hl.dsp.exec_cmd("env XDG_CURRENT_DESKTOP=GNOME gnome-control-center"))

-- Waybar controls
hl.bind(mainMod .. " + H",       hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/wbrestart.sh"))
hl.bind(mainMod .. " + CONTROL + B", hl.dsp.exec_cmd("~/.config/hypr/scripts/WaybarStyles.sh"))
hl.bind(mainMod .. " + ALT + B",    hl.dsp.exec_cmd("~/.config/hypr/scripts/WaybarLayout.sh"))

-- Utilities
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("~/.config/hypr/scripts/KillActiveProcess.sh"))

-- Window management
hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F",     hl.dsp.window.fullscreen())
hl.bind("CONTROL + ALT + Delete",      hl.dsp.exec_cmd("hyprctl dispatch exit 0"))

-- Resize windows (SHIFT+arrows = move in lua; ALT+arrows = resize here)
hl.bind(mainMod .. " + ALT + Left",  hl.dsp.window.resize({ x = -50, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + ALT + Right", hl.dsp.window.resize({ x =  50, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + ALT + Up",    hl.dsp.window.resize({ x = 0, y = -50 }), { repeating = true })
hl.bind(mainMod .. " + ALT + Down",  hl.dsp.window.resize({ x = 0, y =  50 }), { repeating = true })

--------------------
---- WORKSPACES ----
--------------------

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = true }))
    hl.bind(mainMod .. " + ALT + " .. key,   hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(mainMod .. " + CONTROL + Right",       hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + CONTROL + Left",        hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod .. " + CONTROL + Down",        hl.dsp.focus({ workspace = "empty" }))
hl.bind(mainMod .. " + CONTROL + ALT + Right", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod .. " + CONTROL + ALT + Left",  hl.dsp.window.move({ workspace = "r-1" }))

-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-----------------------
---- NOTIFICATIONS ----
-----------------------

hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("swaync-client -t"))

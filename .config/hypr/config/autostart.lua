-- Auto-start config
-- if you dont use UWSM add your auto start programs here, otherwise use XDG autostart https://wiki.archlinux.org/title/XDG_Autostart

hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("xhost +SI:localuser:root")
    hl.exec_cmd("waybar")
    hl.exec_cmd("waypaper --restore")
    hl.exec_cmd("hypridle -c ~/.config/hypr/hypridle-suspend.conf")
end)

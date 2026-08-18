-- Montior wiki https://wiki.hypr.land/Configuring/Basics/Monitors/

-- Fallback for any output not covered by the active hyprmoncfg profile
-- (see ~/.config/hyprmoncfg/profiles/ and the require("monitors") in hyprland.lua).
hl.monitor({
    output    = "",
    mode      = "preferred",
    position  = "auto",
    scale     = "auto",
})

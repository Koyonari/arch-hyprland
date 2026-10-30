hl.config({
    dwindle = {
        preserve_split = true,
    },
    misc = {
        col = {
            splash = CACHYLGREEN,
        },
        middle_click_paste = false,
        enable_swallow = true,
        swallow_regex = "(kitty|ghostty|[Kk]onsole|Alacritty|gnome-terminal|xfce[0-9]?-terminal)",
        vrr = 3,
    },
    debug = {
        -- (formerly misc:vfr) don't render frames when nothing on screen changes
        vfr = true,
    },
    xwayland = {
        force_zero_scaling = true
    },
    render = {
        -- Better frame pacing across monitors running at different refresh
        -- rates (matters once the Dell is at 120 Hz and the BenQ isn't).
        new_render_scheduling = true,
        -- Let fullscreen games (content = "game") bypass compositing.
        direct_scanout = 2,
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
})
-- Environmental variables
-- if you don't use UWSM, define your variables here (e.g. hl.env("QT_QPA_PLATFORM", "wayland"))

-- xwayland { force_zero_scaling = true } makes Xwayland report itself as 1x to
-- X11 apps, so they render normal-DPI UI onto the real 2x-density canvas and
-- end up tiny. Steam's own UI is Chromium-based (not GTK/Qt), so it needs its
-- own scale override rather than GDK_SCALE/QT_SCALE_FACTOR.
hl.env("STEAM_FORCE_DESKTOPUI_SCALING", "2")

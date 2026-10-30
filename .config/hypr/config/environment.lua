-- Environmental variables
-- if you don't use UWSM, define your variables here (e.g. hl.env("QT_QPA_PLATFORM", "wayland"))

-- xwayland { force_zero_scaling = true } makes Xwayland report itself as 1x to
-- X11 apps, so they render normal-DPI UI onto the real 2x-density canvas and
-- end up tiny. Steam's own UI is Chromium-based (not GTK/Qt), so it needs its
-- own scale override rather than GDK_SCALE/QT_SCALE_FACTOR.
hl.env("STEAM_FORCE_DESKTOPUI_SCALING", "2")

-- ── Primary render GPU selection ────────────────────────────────────────────
-- Two GPUs: NVIDIA RTX 3050 (PCI 0000:01:00.0, HDMI port hard-wired to it) and
-- AMD Radeon 680M (PCI 0000:34:00.0, drives eDP + the dock's DisplayPort).
-- Rendering on the iGPU while a 4K panel lives on the dGPU means every frame is
-- copied across PCIe for scanout -> at 4K@120 this saturates the 680M (seen as
-- libinput "event processing lagging behind" + gpu_busy_percent spiking 100%).
--
--   Docked (HDMI live on the dGPU) -> render on the dGPU, native scanout.
--   Undocked                       -> do nothing, Hyprland defaults to the iGPU
--                                     so the dGPU can power down.
--
-- Notes: AQ_DRM_DEVICES is colon-separated and read once at startup, so use
-- plain /dev/dri/cardN paths (by-path names contain ':' and break parsing --
-- this crashed Hyprland on every login once already, see memory), and a
-- dock-state change needs a full logout/login. If this ever blocks login,
-- comment this block out from a TTY.
local function drm_card_for_pci(pci)
    for n = 0, 15 do
        local f = io.open("/sys/class/drm/card" .. n .. "/device/uevent", "r")
        if f then
            local txt = f:read("*a") or ""
            f:close()
            if txt:find("PCI_SLOT_NAME=" .. pci, 1, true) then return n end
        end
    end
    return nil
end

local function connector_connected(card_n, name)
    local f = io.open("/sys/class/drm/card" .. card_n .. "-" .. name .. "/status", "r")
    if not f then return false end
    local s = f:read("*l")
    f:close()
    return s == "connected"
end

local nvidia_n = drm_card_for_pci("0000:01:00.0")
local amd_n    = drm_card_for_pci("0000:34:00.0")

if nvidia_n and amd_n and connector_connected(nvidia_n, "HDMI-A-1") then
    hl.env("AQ_DRM_DEVICES", "/dev/dri/card" .. nvidia_n .. ":/dev/dri/card" .. amd_n)
end

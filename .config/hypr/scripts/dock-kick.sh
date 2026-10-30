#!/usr/bin/env bash
# Force a real mode CHANGE (different refresh, then back) on the BenQ,
# which sits behind the dock's DP-to-HDMI MST converter chip. The converter
# sometimes reports a valid EDID/mode but never actually passes video
# through; a same-mode disable/enable toggle wasn't reliably enough to
# unstick it, but an actual mode change forces it through a real
# renegotiation. stdout/stderr go to the journal (systemd captures them
# under this unit) so we can tell whether/when this actually ran.
BENQ='desc:BNQ ZOWIE XL LCD EBSAM03279SL0'
COOLDOWN=20
LAST_KICK_FILE="${XDG_RUNTIME_DIR:-/tmp}/dock-kick-last"

kick() {
    now=$(date +%s)
    last=$(cat "$LAST_KICK_FILE" 2>/dev/null || echo 0)
    if (( now - last < COOLDOWN )); then
        echo "skip: cooldown active ($(( now - last ))s since last kick)"
        return
    fi
    echo "$now" > "$LAST_KICK_FILE"
    echo "kicking BenQ: disable -> 50Hz -> 60Hz"
    sleep 2
    hyprctl eval "hl.monitor({output=\"$BENQ\", disabled=true})"
    sleep 1
    hyprctl eval "hl.monitor({output=\"$BENQ\", mode=\"1920x1080@50.00\", position=\"0x-1080\", scale=1.0, disabled=false})"
    sleep 1
    hyprctl eval "hl.monitor({output=\"$BENQ\", mode=\"1920x1080@60.00\", position=\"0x-1080\", scale=1.0, disabled=false})"
    echo "kick done"
}

# Cover reboot-while-docked: don't rely solely on catching the "applied"
# log line via journalctl -f, which can race against this service's own
# startup. Check current state directly first.
if hyprctl monitors -j 2>/dev/null | grep -q "BNQ ZOWIE XL LCD EBSAM03279SL0"; then
    echo "BenQ already present at script startup"
    kick
fi

journalctl --user -u hyprmoncfgd -f -n 0 --no-pager -o cat | while read -r line; do
    if [[ "$line" == *"applied profile: docked"* ]]; then
        echo "saw: $line"
        kick
    fi
done

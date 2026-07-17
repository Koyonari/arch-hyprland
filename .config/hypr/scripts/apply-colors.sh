#!/bin/bash
COLORS=~/.config/hypr/colors.conf

get_color() {
    grep "^\$$1 " "$COLORS" | head -1 | awk '{print $3}'
}

PRIMARY=$(get_color "primary")
PRIMARY_CONTAINER=$(get_color "primary_container")
OUTLINE=$(get_color "outline")

[ -z "$PRIMARY" ] && exit 0

hyprctl eval "hl.config({ general = { col = { active_border = { colors = { \"$PRIMARY\", \"$PRIMARY_CONTAINER\" }, angle = 45 }, inactive_border = \"$OUTLINE\" } } })"

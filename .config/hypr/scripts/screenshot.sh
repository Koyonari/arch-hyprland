#!/bin/zsh
mkdir -p "$HOME/Pictures/Screenshots"
grim -g "$(slurp)" "$HOME/Pictures/Screenshots/$(date +'%Y%m%d_%Hh%Mm%Ss_grim').png" &

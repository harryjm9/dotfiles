#!/bin/bash

WALLPAPER_DIR=~/Pictures/wallpapers
STATE_FILE=~/.current_wallpaper_index

# Get all wallpapers in the directory
WALLPAPERS=("$WALLPAPER_DIR"/*)
NUM_WALLPAPERS=${#WALLPAPERS[@]}

# Read last used index, default to -1
if [[ -f $STATE_FILE ]]; then
    LAST_INDEX=$(cat "$STATE_FILE")
else
    LAST_INDEX=-1
fi

# Calculate next index
NEXT_INDEX=$(( (LAST_INDEX + 1) % NUM_WALLPAPERS ))

# Save next index
echo "$NEXT_INDEX" > "$STATE_FILE"

# Start swww if not already running
pgrep -x awww-daemon > /dev/null || awww-daemon &

sleep 0.5  # Give daemon a moment to start

# Set wallpaper on all monitors with animation
for mon in $(hyprctl monitors | grep "Monitor" | awk '{print $2}'); do
    awww img "${WALLPAPERS[$NEXT_INDEX]}" --outputs "$mon" --transition-duration 1.0 --transition-type center
done


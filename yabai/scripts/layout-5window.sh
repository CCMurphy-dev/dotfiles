#!/usr/bin/env bash
# Apply custom layout to current space windows:
#   2 windows:  left 2/3 | right 1/3
#   3 windows:  left 2/3 | right 1/3  /  bottom full-width
#   4 windows:  left 2/3 | right 1/3  /  bottom 1/2 | bottom 1/2
#   5 windows:  left 2/3 | right 1/3  /  bottom 1/3 | 1/3 | 1/3

current_layout=$(yabai -m query --spaces --space | jq -r '.type')

if [[ "$current_layout" == "float" ]]; then
    yabai -m space --layout bsp
    exit 0
fi

windows=($(yabai -m query --windows --space | jq -r '[.[] | select(."is-minimized" == false)] | sort_by(.frame.x, .frame.y) | .[].id'))

count=${#windows[@]}

if [[ $count -lt 2 ]]; then
    echo "Need at least 2 windows for custom layout"
    exit 1
fi

yabai -m space --layout float

if [[ $count -eq 2 ]]; then
    yabai -m window ${windows[0]} --grid 1:3:0:0:2:1
    yabai -m window ${windows[1]} --grid 1:3:2:0:1:1
elif [[ $count -eq 3 ]]; then
    yabai -m window ${windows[0]} --grid 2:6:0:0:4:1
    yabai -m window ${windows[1]} --grid 2:6:4:0:2:1
    yabai -m window ${windows[2]} --grid 2:1:0:1:1:1
elif [[ $count -eq 4 ]]; then
    yabai -m window ${windows[0]} --grid 2:6:0:0:4:1
    yabai -m window ${windows[1]} --grid 2:6:4:0:2:1
    yabai -m window ${windows[2]} --grid 2:2:0:1:1:1
    yabai -m window ${windows[3]} --grid 2:2:1:1:1:1
else
    yabai -m window ${windows[0]} --grid 2:6:0:0:4:1
    yabai -m window ${windows[1]} --grid 2:6:4:0:2:1
    yabai -m window ${windows[2]} --grid 2:3:0:1:1:1
    yabai -m window ${windows[3]} --grid 2:3:1:1:1:1
    yabai -m window ${windows[4]} --grid 2:3:2:1:1:1
fi

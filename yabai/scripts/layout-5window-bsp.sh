#!/usr/bin/env bash
# Apply 5-window layout using native BSP tree construction.
# Builds the tree by inserting windows in sequence, then sets split ratios.
#
# Layout:
#   [  w0 (2/3)  ][  w1 (1/3)  ]
#   [ w2 ][ w3 ][ w4 ]  (equal thirds)
#
# BSP tree built:
#   root [h-split 0.5]
#   ├── [v-split 0.667] → w0 | w1
#   └── [v-split 0.333] → w2 | [v-split 0.5] → w3 | w4

windows=($(yabai -m query --windows --space | jq -r '[.[] | select(."is-minimized" == false)] | sort_by(.frame.x, .frame.y) | .[].id'))

count=${#windows[@]}

if [[ $count -ne 5 ]]; then
    echo "layout-5window-bsp requires exactly 5 windows (found $count)"
    echo "Use layout-5window.sh for 2-5 window support"
    exit 1
fi

w0=${windows[0]}
w1=${windows[1]}
w2=${windows[2]}
w3=${windows[3]}
w4=${windows[4]}

# Float all managed windows to clear the BSP tree
for wid in "${windows[@]}"; do
    is_floating=$(yabai -m query --windows --window $wid | jq '."is-floating"')
    if [[ "$is_floating" == "false" ]]; then
        yabai -m window $wid --toggle float
    fi
done

yabai -m space --layout bsp

# Build BSP tree by inserting windows in order:
# 1. w0 → fills screen (root leaf)
yabai -m window $w0 --toggle float

# 2. Insert w2 south of w0 → root splits h: top=w0, bottom=w2
yabai -m window --focus $w0
yabai -m window --insert south
yabai -m window $w2 --toggle float

# 3. Insert w1 east of w0 → top splits v: left=w0, right=w1
yabai -m window --focus $w0
yabai -m window --insert east
yabai -m window $w1 --toggle float

# 4. Insert w3 east of w2 → bottom splits v: left=w2, right=w3
yabai -m window --focus $w2
yabai -m window --insert east
yabai -m window $w3 --toggle float

# 5. Insert w4 east of w3 → right-bottom splits v: left=w3, right=w4
yabai -m window --focus $w3
yabai -m window --insert east
yabai -m window $w4 --toggle float

# Set split ratios
# Top row: w0=2/3, w1=1/3
yabai -m window --focus $w0
yabai -m window --ratio abs:0.6667

# Bottom row: w2=1/3, [w3+w4]=2/3
yabai -m window --focus $w2
yabai -m window --ratio abs:0.3333

# w3 and w4 split evenly
yabai -m window --focus $w3
yabai -m window --ratio abs:0.5000

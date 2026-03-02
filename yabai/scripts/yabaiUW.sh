#!/usr/bin/env bash
# ~/.config/yabai/scripts/yabaiUW.sh
# Custom padding for ultrawide monitor (21:9 aspect ratio)
# Display 1 (MacBook) uses standard yabai config

# Get the focused space's display
DISPLAY_ID=$(yabai -m query --spaces --space | jq '.display')

# Skip MacBook internal display (always display 1)
[[ $DISPLAY_ID == 1 ]] && exit 0

# Check if external display is ultrawide (21:9 ≈ 2.37 ratio vs 16:9 ≈ 1.78)
display_info=$(yabai -m query --displays --display "$DISPLAY_ID")
display_width=$(echo "$display_info" | jq '.frame.w | floor')
display_height=$(echo "$display_info" | jq '.frame.h | floor')

# Integer arithmetic: multiply by 100 to avoid floats
# Ultrawide ~237, Standard ~178 — threshold of 200 safely separates them
aspect_ratio=$((display_width * 100 / display_height))
if [[ $aspect_ratio -le 200 ]]; then
  # External non-ultrawide: bump top padding for Aegis menu bar, keep other defaults
  yabai -m space --padding abs:40:20:40:40
  exit 0
fi

# Count visible, non-floating windows on the current space
windows=$(yabai -m query --windows --space | jq '[.[] | select(."is-visible"==true and ."is-floating"==false and ."is-tab"==false)] | length')

# Ultrawide 2560x1080 (21:9)
# Format: abs:top:bottom:left:right
if [[ $windows -le 1 ]]; then
  # Single window: center it with large side padding
  yabai -m space --padding abs:40:20:400:400
elif [[ $windows == 2 ]]; then
  # Two windows: moderate padding
  yabai -m space --padding abs:40:20:150:150
elif [[ $windows == 3 ]]; then
  # Three windows: tighter padding
  yabai -m space --padding abs:40:20:80:80

  # Only adjust layout on window_created/destroyed events, not on focus changes
  # This prevents the layout from constantly shifting
  if [[ "$YABAI_EVENT_TYPE" == "window_created" ]] || [[ "$YABAI_EVENT_TYPE" == "window_destroyed" ]] || [[ -z "$YABAI_EVENT_TYPE" ]]; then
    # Adjust 3-column layout: make center window wider
    # Target widths: Left 25%, Center 50%, Right 25%
    # Usable width: 2560 - 80 - 80 - 15 - 15 = 2370px
    # Left: 593px, Center: 1184px, Right: 593px

    # Get windows sorted by x-position
    windows_json=$(yabai -m query --windows --space | jq '[.[] | select(."is-visible"==true and ."is-floating"==false and ."is-tab"==false)] | sort_by(.frame.x)')

    if [[ $(echo "$windows_json" | jq 'length') -eq 3 ]]; then
      # Get current widths (as integers)
      left_width=$(echo "$windows_json" | jq '.[0].frame.w | floor')
      right_width=$(echo "$windows_json" | jq '.[2].frame.w | floor')

      left_id=$(echo "$windows_json" | jq '.[0].id')
      right_id=$(echo "$windows_json" | jq '.[2].id')

      # Target: left=593, right=593
      # Only resize if we're more than 20px off target
      left_delta=$((593 - left_width))
      right_delta=$((593 - right_width))

      # Only apply if delta is significant (more than 20px off)
      if [[ ${left_delta#-} -gt 20 ]]; then
        yabai -m window "$left_id" --resize right:$left_delta:0
      fi

      if [[ ${right_delta#-} -gt 20 ]]; then
        yabai -m window "$right_id" --resize left:$((-right_delta)):0
      fi
    fi
  fi
else
  # 4+ windows: minimal padding
  yabai -m space --padding abs:40:20:40:40
fi

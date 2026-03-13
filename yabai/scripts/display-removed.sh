#!/usr/bin/env bash
# On display disconnect: rescue windows from the destroyed space into a new preserved space.
# Called on display_removed signal (YABAI_DISPLAY_ID set by yabai).

STATE_FILE="$HOME/.config/yabai/display-state.json"

[[ ! -f "$STATE_FILE" ]] && exit 0

# Brief pause for yabai to finish moving windows
sleep 0.5

# Look up the removed display's UUID and last-known windows from cache
entry=$(jq -r --arg id "${YABAI_DISPLAY_ID}" '.[$id] // empty' "$STATE_FILE")
[[ -z "$entry" ]] && exit 0

display_uuid=$(echo "$entry" | jq -r '.uuid')
window_ids=$(echo "$entry" | jq -r '.windows[]' 2>/dev/null)

[[ -z "$window_ids" ]] && exit 0

# Create a new space on the internal display to preserve these windows
yabai -m space --create

# Get the newly created space's index (highest index)
new_space_idx=$(yabai -m query --spaces | jq 'max_by(.index) | .index')

# Label the space so we can find it on reconnect
yabai -m space "$new_space_idx" --label "extdisp-${display_uuid}"

# Move each rescued window to the new space
for wid in $window_ids; do
    exists=$(yabai -m query --windows --window "$wid" 2>/dev/null)
    [[ -z "$exists" ]] && continue
    yabai -m window "$wid" --space "$new_space_idx" 2>/dev/null
done

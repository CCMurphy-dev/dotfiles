#!/usr/bin/env bash
# On display reconnect: move the preserved space back to the external display.
# Called on display_added signal (YABAI_DISPLAY_ID set by yabai).

LOG="/tmp/yabai-display-restore.log"
echo "=== display_added fired at $(date) ===" > "$LOG"
echo "YABAI_DISPLAY_ID=${YABAI_DISPLAY_ID}" >> "$LOG"

# Poll until the new display appears in yabai's display list (up to 10s)
display_info=""
for i in $(seq 1 20); do
    display_info=$(yabai -m query --displays | jq -r \
        --argjson id "${YABAI_DISPLAY_ID}" \
        '.[] | select(.id == $id) | "\(.uuid) \(.index)"')
    [[ -n "$display_info" ]] && break
    sleep 0.5
done
echo "Waited ${i} polls for display to register" >> "$LOG"

# Dump current displays for debugging
yabai -m query --displays >> "$LOG" 2>&1

echo "display_info=${display_info}" >> "$LOG"
[[ -z "$display_info" ]] && { echo "ERROR: display not found" >> "$LOG"; exit 1; }

display_uuid=$(echo "$display_info" | awk '{print $1}')
display_index=$(echo "$display_info" | awk '{print $2}')

# Find the preserved space by its label
label="extdisp-${display_uuid}"
echo "Looking for space with label: ${label}" >> "$LOG"

# Dump current spaces for debugging
yabai -m query --spaces | jq '[.[] | {index, label, display}]' >> "$LOG" 2>&1

space_index=$(yabai -m query --spaces | jq -r \
    --arg label "$label" \
    '.[] | select(.label == $label) | .index')

echo "space_index=${space_index}" >> "$LOG"
[[ -z "$space_index" ]] && { echo "ERROR: labeled space not found" >> "$LOG"; exit 0; }

# Move the space to the reconnected external display using label as selector
echo "Moving space $space_index (label: $label) to display $display_index" >> "$LOG"
yabai -m space "$label" --display "$display_index" 2>> "$LOG"

sleep 1

# Dump spaces after move for debugging
echo "Spaces after move:" >> "$LOG"
yabai -m query --spaces | jq '[.[] | {index, label, display, windows: (.windows | length)}]' >> "$LOG" 2>&1

# Destroy all auto-created empty spaces yabai added on reconnect (loop since indices shift after each destroy)
for attempt in $(seq 1 10); do
    empty_idx=$(yabai -m query --spaces | jq -r \
        --arg label "$label" \
        --argjson didx "$display_index" \
        '[.[] | select(.display == $didx and (.windows | length) == 0 and .label != $label)] | .[0].index // empty')
    [[ -z "$empty_idx" ]] && break
    echo "Destroying empty space $empty_idx (attempt $attempt)" >> "$LOG"
    yabai -m space "$empty_idx" --destroy 2>> "$LOG"
    sleep 0.3
done
echo "Spaces after cleanup:" >> "$LOG"
yabai -m query --spaces | jq '[.[] | {index, label, display, windows: (.windows | length)}]' >> "$LOG" 2>&1

# Clear the label now that it's restored
yabai -m space "$label" --label "" 2>> "$LOG"
echo "Done" >> "$LOG"

#!/usr/bin/env bash
# Snapshot display→window state to cache.
# Called on window_created, window_destroyed, window_moved, space_changed, display_changed.
# Cache format: { "<display_id>": { "uuid": "...", "windows": [ids] } }

STATE_FILE="$HOME/.config/yabai/display-state.json"

displays=$(yabai -m query --displays)
windows=$(yabai -m query --windows)

jq -n \
    --argjson displays "$displays" \
    --argjson windows "$windows" \
    '
    # Build display index → {id, uuid} map
    ($displays | map({key: (.index | tostring), value: {id: .id, uuid: .uuid}}) | from_entries) as $idx_map |

    # Group windows by display index, key output by display hardware id
    ($windows | group_by(.display) | map(
        . as $group |
        ($idx_map[($group[0].display | tostring)] // {id: "unknown", uuid: "unknown"}) as $disp |
        {key: ($disp.id | tostring), value: {uuid: $disp.uuid, windows: ($group | map(.id))}}
    ) | from_entries)
    ' > "$STATE_FILE"

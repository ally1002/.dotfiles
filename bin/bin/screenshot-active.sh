#!/usr/bin/env bash
set -euo pipefail

# Check for required dependencies
check_deps() {
    local missing=()
    for cmd in hyprctl jq grim wl-copy; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "Error: Missing dependencies: ${missing[*]}" >&2
        exit 1
    fi
}

# Get active window geometry in grim format
get_active_window_geometry() {
    local json
    json=$(hyprctl activewindow -j)
    
    # Check if there's an active window
    if [[ "$json" == "null" ]] || [[ -z "$json" ]]; then
        echo "Error: No active window" >&2
        return 1
    fi
    
    echo "$json" | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
}

# Capture region and copy to clipboard
capture_to_clipboard() {
    local geometry="$1"
    grim -g "$geometry" - | wl-copy
}

# Show optional notification
notify_success() {
    if command -v notify-send &>/dev/null; then
        notify-send -t 2000 "Screenshot" "Active window captured to clipboard"
    fi
}

# Main entry point
main() {
    check_deps
    
    local geometry
    geometry=$(get_active_window_geometry)
    
    capture_to_clipboard "$geometry"
    notify_success
}

main "$@"

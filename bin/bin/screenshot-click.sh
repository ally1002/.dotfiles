#!/usr/bin/env bash
set -euo pipefail

# Required dependencies
REQUIRED_DEPS=(hyprctl jq slurp grim wl-copy)

# Default options
DELAY=0

check_deps() {
    local missing=()
    for dep in "${REQUIRED_DEPS[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing+=("$dep")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "Missing dependencies: ${missing[*]}" >&2
        exit 1
    fi
}

get_window_geometries() {
    hyprctl clients -j | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
}

select_window() {
    local geometries
    geometries=$(get_window_geometries)

    if [[ -z "$geometries" ]]; then
        echo "No windows found" >&2
        exit 1
    fi

    # slurp -r restricts to predefined regions only (no free-form drawing)
    echo "$geometries" | slurp -r || exit 1
}

capture_to_clipboard() {
    local geometry="$1"
    grim -g "$geometry" - | wl-copy
}

notify_success() {
    if command -v notify-send &>/dev/null; then
        notify-send "Screenshot" "Window captured to clipboard"
    fi
}

delay_capture() {
    local seconds="$1"
    sleep "$seconds"
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --delay)
                if [[ -z "${2:-}" ]] || [[ ! "$2" =~ ^[0-9]+$ ]]; then
                    echo "Error: --delay requires a numeric argument" >&2
                    exit 1
                fi
                DELAY="$2"
                shift 2
                ;;
            --help|-h)
                echo "Usage: screenshot-click.sh [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --delay N    Wait N seconds before capture"
                echo "  --help, -h   Show this help message"
                exit 0
                ;;
            *)
                echo "Unknown option: $1" >&2
                exit 1
                ;;
        esac
    done
}

main() {
    parse_args "$@"
    check_deps

    local selected
    selected=$(select_window)

    if [[ "$DELAY" -gt 0 ]]; then
        delay_capture "$DELAY"
    fi

    capture_to_clipboard "$selected"
    notify_success
}

main "$@"

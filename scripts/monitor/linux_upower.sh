#!/usr/bin/env bash


priority () {
    echo "1"
}

is_runnable () {
    [[ "$(uname -s)" == "Linux" ]] && \
    command -v "upower" >/dev/null 2>&1
}

run_monitor() {
    # First print the current status and then monitor AC change events
    upower --dump | stdbuf -oL grep online | stdbuf -oL awk '{ print ($2 == "no") ? "battery" : "ac" }'
    upower --monitor-detail | stdbuf -oL grep online | stdbuf -oL awk '{ print ($2 == "no") ? "battery" : "ac" }'
}

# If the script is run standalone and not being sourced
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    run_monitor
fi

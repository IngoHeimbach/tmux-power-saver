#!/usr/bin/env bash


priority () {
    echo "1"
}

is_runnable () {
    [[ "$(uname -s)" == "Linux" ]] && \
    command -v "upower" >/dev/null 2>&1
}

run_monitor() {
    cleanup () {
        if [[ -n "${UPOWER_PID}" ]]; then
            kill "${UPOWER_PID}"
        fi
    }
    trap cleanup EXIT

    # First print the current status and then monitor AC change events
    upower --dump | stdbuf -oL grep online | stdbuf -oL awk '{ print ($2 == "no") ? "battery" : "ac" }'
    # Use a subshell redirection to get the correct PID in the next step (`$!`)
    upower --monitor-detail > >(stdbuf -oL grep online | stdbuf -oL awk '{ print ($2 == "no") ? "battery" : "ac" }') &
    UPOWER_PID="$!"
    wait "${UPOWER_PID}"
}

# If the script is run standalone and not being sourced
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    run_monitor
fi

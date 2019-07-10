#!/usr/bin/env bash


priority () {
    # `-1` indicates that the plugin should not be used currently
    echo "-1"
}

is_runnable () {
    [[ "$(uname -s)" == "Linux" ]] && \
    command -v "upower" >/dev/null 2>&1
}

run_monitor() {
    # Implement me!
    return 1
}

# If the script is run standalone and not being sourced
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    run_monitor
fi

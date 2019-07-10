#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


priority () {
    echo "1"
}


is_runnable () {
    [[ "$(uname -s)" == "Darwin" ]] && \
    make -C "${CURRENT_DIR}/macos_io_power_sources" >/dev/null 2>&1
}

run_monitor () {
    "${CURRENT_DIR}/macos_io_power_sources/battery_check"
}

# If the script is run standalone and not being sourced
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    run_monitor
fi

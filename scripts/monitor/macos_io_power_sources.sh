#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$(cd "${CURRENT_DIR}/../" && pwd)"

# shellcheck source=../utils.sh
source "${SCRIPTS_DIR}/utils.sh"


priority () {
    echo "1"
}


is_runnable () {
    [[ "$(uname -s)" == "Darwin" ]] && \
    make -C "${CURRENT_DIR}/macos_io_power_sources" >/dev/null 2>&1
}

run_monitor () {
    cleanup () {
        if [[ -n "${BATTERY_CHECK_PID}" ]]; then
            kill "${BATTERY_CHECK_PID}"
        fi
    }
    trap cleanup EXIT

    "${CURRENT_DIR}/macos_io_power_sources/battery_check" &
    BATTERY_CHECK_PID="$!"
    wait "${BATTERY_CHECK_PID}"
}

# If the script is run standalone and not being sourced
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    run_monitor
fi

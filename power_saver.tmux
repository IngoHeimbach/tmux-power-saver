#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${CURRENT_DIR}/scripts"


main() {
    local previous_processes pid

    # Ensure previous instances are killed before a new is started
    mapfile -t previous_processes <<< "$(ps -e -o "pid=,command=" | grep 'monitor_power_supply\.sh' | awk '{ print $1 }')"
    for pid in "${previous_processes[@]}"; do
        kill "${pid}"
    done
    "${SCRIPTS_DIR}/monitor_power_supply.sh" &
}

main

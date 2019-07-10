#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${CURRENT_DIR}/scripts"


kill_previous_instances () {
    local previous_processes pid

    mapfile -t previous_processes <<< "$(ps -e -o "pid=,command=" | grep 'monitor_power_supply\.sh' | awk '{ print $1 }')"
    [[ "${#previous_processes}" -gt 0 ]] || return 0
    for pid in "${previous_processes[@]}"; do
        kill "${pid}"
    done
}


main() {
    # Ensure previous instances are killed before a new is started
    kill_previous_instances
    "${SCRIPTS_DIR}/monitor_power_supply.sh" &
}

main

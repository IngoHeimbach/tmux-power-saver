#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${CURRENT_DIR}/scripts"

# shellcheck source=./utils.sh
source "${SCRIPTS_DIR}/utils.sh"

main() {
    # Ensure previous instances are killed before a new is started
    kill_previous_instances
    "${SCRIPTS_DIR}/monitor_power_supply.sh" &
}

main

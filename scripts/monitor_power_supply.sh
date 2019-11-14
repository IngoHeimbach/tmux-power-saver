#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${CURRENT_DIR}"

# shellcheck source=./utils.sh
source "${SCRIPTS_DIR}/utils.sh"

export POWER_SAVER_POLLING_INTERVAl="30"
POWER_SAVER_BATTERY_INTERVAL_DEFAULT="20"
POWER_SAVER_BATTERY_INTERVAL_OPTION="@power-saver-battery-interval"
POWER_SAVER_AC_INTERVAL_DEFAULT="2"
POWER_SAVER_AC_INTERVAL_OPTION="@power-saver-ac-interval"

MONITOR_SCRIPT=""


cleanup () {
    if [[ -n "${MONITOR_SCRIPT}" ]]; then
        kill_instances "${MONITOR_SCRIPT}"
    fi
}
trap cleanup EXIT

power_saver_battery_interval() {
    get_tmux_option "${POWER_SAVER_BATTERY_INTERVAL_OPTION}" "${POWER_SAVER_BATTERY_INTERVAL_DEFAULT}"
}

power_saver_ac_interval() {
    get_tmux_option "${POWER_SAVER_AC_INTERVAL_OPTION}" "${POWER_SAVER_AC_INTERVAL_DEFAULT}"
}

find_suitable_monitor_plugin () (
    local script best_script max_priority current_priority

    max_priority=-1
    for script in "${CURRENT_DIR}"/monitor/*.sh; do
        source "${script}" || continue
        if is_runnable; then
            current_priority="$(priority)"
            if [[ "${current_priority}" -gt "${max_priority}" ]]; then
                max_priority="${current_priority}"
                best_script="${script}"
            fi
        fi
    done

    [[ -n "${best_script}" ]] || return 1

    echo "${best_script}"
)

monitor_power_supply () {
    local battery_command ac_command last_power_type current_power_type

    battery_command="$1"
    ac_command="$2"

    MONITOR_SCRIPT="$(find_suitable_monitor_plugin)"

    while read -r current_power_type; do
        if [[ "${current_power_type}" != "${last_power_type}" ]]; then
            if [[ "${current_power_type}" == "battery" ]]; then
                ${battery_command}
            elif [[ "${current_power_type}" == "ac" ]]; then
                ${ac_command}
            else
                # this branch should not be executed in a sane implementation
                return 1
            fi
            last_power_type="${current_power_type}"
        fi
    done < <("${MONITOR_SCRIPT}" 2>/dev/null)
}

main() {
    monitor_power_supply "tmux set -g status-interval $(power_saver_battery_interval)" \
                         "tmux set -g status-interval $(power_saver_ac_interval)" || { \
        display_message "Failed to monitor the power supply."; return 1; \
    }
}

main

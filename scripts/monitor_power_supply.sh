#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${CURRENT_DIR}"

# shellcheck source=./helpers.sh
source "${SCRIPTS_DIR}/helpers.sh"

POWER_SAVER_BATTERY_INTERVAL_DEFAULT="20"
POWER_SAVER_BATTERY_INTERVAL_OPTION="@power-saver-battery-interval"
POWER_SAVER_AC_INTERVAL_DEFAULT="2"
POWER_SAVER_AC_INTERVAL_OPTION="@power-saver-ac-interval"
POWER_SAVER_POLLING_INTERVAl="30"

power_saver_battery_interval() {
    get_tmux_option "${POWER_SAVER_BATTERY_INTERVAL_OPTION}" "${POWER_SAVER_BATTERY_INTERVAL_DEFAULT}"
}

power_saver_ac_interval() {
    get_tmux_option "${POWER_SAVER_AC_INTERVAL_OPTION}" "${POWER_SAVER_AC_INTERVAL_DEFAULT}"
}

power_source_type () {
    local os

    os="$(get_os)"
    if [[ "${os}" == "Darwin" ]]; then
        if pmset -g batt | head -1 | grep -q "Battery"; then
            echo "battery"
        else
            echo "ac"
        fi
    elif [[ "${os}" == "Linux" ]]; then
        >&2 echo "Linux will be supported in the next version."
        return 1
    else
        >&2 echo "Unsupported operating system"
        return 1
    fi
}

monitor_power_supply () {
    local battery_command ac_command last_power_type current_power_type

    battery_command="$1"
    ac_command="$2"

    while true; do
        current_power_type="$(power_source_type)"
        if [[ "${current_power_type}" != "${last_power_type}" ]]; then
            if [[ "${current_power_type}" == "battery" ]]; then
                ${battery_command}
            elif [[ "${current_power_type}" == "ac" ]]; then
                ${ac_command}
            else
                >&2 echo "Unsupported power type"
            fi
            last_power_type="${current_power_type}"
        fi
        sleep "${POWER_SAVER_POLLING_INTERVAl}"
    done
}

main() {
    monitor_power_supply "tmux set -g status-interval $(power_saver_battery_interval)" \
                         "tmux set -g status-interval $(power_saver_ac_interval)" || { \
        display_message "Failed to monitor the power supply."; return 1; \
    }
}

main

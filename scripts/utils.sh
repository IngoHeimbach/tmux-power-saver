#!/usr/bin/env bash

display_message() {
    tmux display-message "$1"
}

get_tmux_option() {
    local option="$1"
    local default_value="$2"
    local option_value
    option_value="$(tmux show-option -gqv "${option}")"
    if [[ -z "${option_value}" ]]; then
        echo "${default_value}"
    else
        echo "${option_value}"
    fi
}

get_os () {
    uname -s
}

command_available () {
    local cmd

    cmd="$1"
    command -v "${cmd}" >/dev/null 2>&1
}

kill_instances () {
    local instance_name previous_processes pid

    instance_name="$1"
    if [[ -z "${instance_name}" ]]; then
        instance_name="monitor_power_supply\.sh$"
    fi
    mapfile -t previous_processes <<< "$(ps -e -o "pid=,command=" | grep "${instance_name}" | awk '{ print $1 }')"
    [[ "${#previous_processes}" -gt 0 ]] || return 0
    for pid in "${previous_processes[@]}"; do
        kill "${pid}"
    done
}

#!/usr/bin/env bash


priority () {
    echo "0"
}

is_runnable () {
    [[ "$(uname -s)" == "Linux" ]] && \
    command -v "acpi" >/dev/null 2>&1
}

run_monitor () {
    while true; do
        if acpi -a | grep -q "off-line"; then
            echo "battery"
        else
            echo "ac"
        fi
        sleep "${POWER_SAVER_POLLING_INTERVAl}"
    done
}

# If the script is run standalone and not being sourced
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    run_monitor
fi

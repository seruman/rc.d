#!/usr/bin/env bash

function __check_colima_binary() {
	command -v colima &>/dev/null
}

function __format(){
    local icon=$1
    local color_icon=$2

    local text_left=$3
    local color_text_left=$4

    local text_right=$5
    local color_text_right=$6

    echo -en "#[fg=${color_icon}]${icon} #[fg=${color_text_left}]${text_left}#[fg=${color_text_right}]${text_right}"
}

function __format_profile() {
	local profile="$1"
    local icon="$2"
    local color_text="$3"
    local color_icon="$4"
	local running_color="$5"
	local stopped_color="$6"
    
    local _text_profile="N/A"
    local _color_status="$stopped_color"

	while read -r column_profile column_status _rest; do
        [[ "$column_profile" != "$profile" ]] && continue
        
        _text_profile="$column_profile"
        if [[ "$column_status" == "Running" ]]; then
            _color_status="$running_color"
        else
            _color_status="$stopped_color"
        fi
	done < <(colima list | tail -n +2)

    __format "$icon" "$color_icon" "colima:" "$_text_profile" "$color_text" "$_color_status"
}

function colima-tmux() {
	local profile="${COLIMA_TEMUX_DEFAULT_PROFILE:-default}"
    local icon="${COLIMA_TMUX_ICON:-}"
	local color=${COLIMA_TMUX_COLOR:-"default"}
    local color_icon=${COLIMA_TMUX_COLOR_ICON:-"blue"}
	local color_running=${COLIMA_TMUX_COLOR_RUNNING:-"green"}
	local color_stopped=${COLIMA_TMUX_COLOR_STOPPED:-"red"}

	while [[ $# -gt 0 ]]; do
		case "$1" in
		-p | --profile)
            profile="${2-$profile}"
			shift
			shift
			;;
        -i | --icon)
            icon="${2-$icon}"
            shift
            shift
            ;;
		-c | --color)
			color="${2-$color}"
			shift
			shift
			;;
        -ci | --color-icon)
            color_icon="${2-$color_icon}"
            shift
            shift
            ;;
		-cr | --color-running)
			color_running="${2-$color_running}"
			shift
			shift
			;;
		-cs | --color-stopped)
			color_stopped="${2-$color_stopped}"
			shift
			shift
			;;
		*)
			echo "Unknown argument: $1"
			exit 1
			;;
		esac
	done

    if ! __check_colima_binary; then
        __format "$icon" "$color_icon" "colima:" "$color" "NOT-FOUND" "$color" "$color_stopped"
        return
    fi

	__format_profile "${profile}" "${icon}" "${color}" "${color_icon}" "${color_running}" "${color_stopped}"
}

colima-tmux "$@"

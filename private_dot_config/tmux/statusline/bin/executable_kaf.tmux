#!/usr/bin/env bash

function kaf-tmux() {
	local icon="${KAF_TMUX_ICON:-🌊}"
	local color=${KAF_TMUX_COLOR:-"default"}
	local context_color=${KAF_TMUX_CONTEXT_COLOR:-"green"}
	local prefix=${KAF_TMUX_PREFIX:-"kaf"}

	while [[ "$#" -gt 0 ]]; do
		case $1 in
		-i | --icon)
			icon="$2"
			shift
			;;
		-c | --color)
			color="$2"
			shift
			;;
		-cc | --context-color)
			context_color="$2"
			shift
			;;
		-p | --prefix)
			prefix="$2"
			shift
			;;
		*)
			echo "Unknown parameter passed: $1"
			exit 1
			;;
		esac
		shift
	done

    if ! command -v kaf >/dev/null 2>&1; then
        return
    fi

	local current_context='N/A'
	if command -v kaf >/dev/null 2>&1; then
		current_context=$(kaf config current-context 2>/dev/null)
	fi

	if [[ -z "$current_context" ]]; then
		context_color="red"
		current_context="N/A"
	fi

	echo "#[fg=$color]$icon#[fg=default] $prefix:#[fg=$context_color]$current_context#[fg=default]"

}

kaf-tmux "$@"

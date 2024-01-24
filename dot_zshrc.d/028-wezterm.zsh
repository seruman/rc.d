if [[ "$TERM_PROGRAM" != "WezTerm" ]]; then
    return
fi

if [[ "$OS" != "Darwin" ]]; then
    return
fi

local wezterm_integration_script="$(dirname $(dirname $WEZTERM_EXECUTABLE))/Resources/wezterm.sh"
if [[ ! -f "$wezterm_integration_script" ]]; then
    unset wezterm_integration_script
    return
fi

source "$wezterm_integration_script"
unset wezterm_integration_script

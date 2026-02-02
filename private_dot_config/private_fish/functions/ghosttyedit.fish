function ghosttyedit
    # open -a Ghostty -n --args --quit-after-last-window-closed=true --macos-titlebar-style=hidden --command="$(which fish) -c 'exec nvim $argv'" 
    open -a Ghostty -n --args --quit-after-last-window-closed=true --macos-titlebar-style=hidden --command="$(which nvim) $argv"
end

# #!/bin/bash
#
#
# input_file="$1"
#
# # Open in Ghostty with nvim
# open -a Ghostty -n --args --command="/opt/homebrew/bin/fish -c 'exec nvim \"$input_file\"'" --quit-after-last-window-closed=true --macos-titlebar-style=hidden
#
#default_shell=$(dscl . -read /Users/$USER UserShell | sed 's/UserShell: //')
# exec $default_shell -c "ghosttyedit $@"

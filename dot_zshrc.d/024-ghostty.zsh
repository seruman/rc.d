if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
	path=(/Applications/Ghostty.app/Contents/MacOS $path)
    
    if [[ -n $TMUX ]]; then
        autoload -Uz -- "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
        ghostty-integration
        unfunction ghostty-integration
    fi
fi

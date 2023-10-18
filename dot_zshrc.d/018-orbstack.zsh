if [[ $(command -v orb) && $(command -v orbctl) ]]; then
    if [[ -f "$HOME/.orbstack/shell/init.zsh" ]]; then
        source $HOME/.orbstack/shell/init.zsh
    fi
fi

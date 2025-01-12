if command -sq orb && command -sq orbctl
    and test -f "$HOME/.orbstack/shell/init.fish"
    source "$HOME/.orbstack/shell/init.fish"
end

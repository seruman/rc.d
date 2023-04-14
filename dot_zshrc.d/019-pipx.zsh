# vi: ft=zsh

if [[ -n "$(command -v pipx)" ]]; then
    path=(
        "$HOME/.local/bin"
        $path
    )
fi

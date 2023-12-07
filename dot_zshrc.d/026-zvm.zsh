if [[ -n "$(command -v zvm)" ]]; then
    path=(
        "$HOME/.zvm/self"
        "$HOME/.zvm/bin"
        $path
    )
fi

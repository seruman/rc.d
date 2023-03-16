# vi: ft=zsh

if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --inline-info --border'
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
fi


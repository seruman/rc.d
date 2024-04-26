# vi: ft=zsh

# start typing + [Up/Down-Arrow] - fuzzy find history forward
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line


function _gitsemtag(){
    if [[ ! -d .git ]]; then
        zle reset-prompt
        return 0
    fi

    local tags=$(git semtag -r -ii -fc)
    if [[ -z $tags ]]; then
        zle reset-prompt
        return 0
    fi

    local selection=$(echo $tags | fzf --ansi --height 40% --reverse --prompt="semtag> " --preview="git show --color {1}")
    if [[ -z $selection ]]; then
        zle reset-prompt
        return 0
    fi

    LBUFFER="${LBUFFER}${selection}"
    zle reset-prompt
    return 0
}

zle -N _gitsemtag{,}
bindkey '^x^t' _gitsemtag

# vi: ft=zsh

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --inline-info --border'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'


function _fzf__path(){
    local fzf_path=$HOME/.fzf
    if [[ ! -d $fzf_path ]]; then
        if [[ -n $(command -v brew) ]]; then
            fzf_path=$(brew --prefix fzf)
        else
            fzf_path=""
        fi
    fi

    [[ -d $fzf_path ]] && echo $fzf_path
}

# Auto-completion & key-bindings
if [[ $- == *i* ]]; then
    if [[ -n "$(_fzf__path)" ]]; then
        source "$(_fzf__path)/shell/completion.zsh"
        source "$(_fzf__path)/shell/key-bindings.zsh"
    fi
fi

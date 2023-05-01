# vi: ft=zsh

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --inline-info --border'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/selman/.fzf/shell/completion.zsh" 2>/dev/null

# Key bindings
# ------------
source "/Users/selman/.fzf/shell/key-bindings.zsh"

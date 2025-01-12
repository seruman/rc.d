if command -sq fzf
    # Set FZF environment variables
    set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse --inline-info --border'
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git'

    # Source fzf key bindings only in interactive sessions
    if status is-interactive
        fzf --fish | source
    end
end

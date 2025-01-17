function __fish_git_semtag
    # Check if we're in a git repo first
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        return 1
    end

    # Get tags
    set -l tags (git semtag -r -ii -fc)
    if not test -n "$tags"
        return
    end

    # Get selection from fzf
    set -l selection (string split \n -- $tags | \
        fzf --ansi \
            --prompt="semtag> " \
            --preview="git show --color {1}")

    commandline -f repaint
    if test -n "$selection"
        commandline -i -- $selection
    end
end

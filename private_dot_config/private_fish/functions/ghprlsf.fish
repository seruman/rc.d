function ghprlsf --wraps "gh pr list" --description "Fuzzy find GitHub PRs and open in browser"
    set -lx GH_FORCE_TTY yes
    set -l pr_number (gh pr list | \
        fzf --ansi \
            --header-lines 4 \
            --preview 'GH_FORCE_TTY=yes gh pr view {1}' | \
        awk '{print $1}')
    
    if test -n "$pr_number"
        gh pr view --web $pr_number
    end
end

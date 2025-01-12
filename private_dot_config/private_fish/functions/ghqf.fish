function ghqf --wraps ghq --description 'Fuzzy find and navigate ghq repositories'
    set -l repopath (ghq list | \
        fzf \
            --ansi \
            --prompt 'Repositories> ' \
            --preview '_ghqf_preview {}' \
            --query "$argv" | \
        xargs -I{} ghq list --full-path -e {})

    if test -n "$repopath"
        cd "$repopath"
    end
end

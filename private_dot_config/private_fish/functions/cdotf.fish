function cdotf --description 'Navigate to chezmoi managed directories'
    set -l chezmoi_target (chezmoi target-path)
    set -l previewcmd "CLICOLOR_FORCE=1 ls $chezmoi_target/{}"

    set -l dir (chezmoi managed -i dirs | \
        fzf \
            --prompt 'Dotfiles> ' \
            --preview "$previewcmd" \
            --query "$argv"
    )

    if test -n "$dir"
        set -l absdir "$chezmoi_target/$dir"
        if test -d "$absdir"
            cd "$absdir"
        end
    end
end

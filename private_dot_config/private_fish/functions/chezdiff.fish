function chezdiff --description 'Preview chezmoi changes with fzf'
    set -l selected_file (chezmoi status -p absolute | \
        awk '{print $2}' | \
        fzf --preview 'chezmoi --color true diff {}' \
            --multi \
            --preview-window=right:60%:wrap)

    if test -n "$selected_file"
        # print the file names
        string join ' ' $selected_file
    end
end

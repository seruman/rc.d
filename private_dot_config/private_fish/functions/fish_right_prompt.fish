function fish_right_prompt

    for item in $fish_right_prompt_items
        set -l got (eval $item)
        if test -n "$got"
            echo -n "$got"
            echo -n " "
        end
    end
end

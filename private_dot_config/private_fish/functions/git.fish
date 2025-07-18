function git --wraps=git
    # NOTE: Heavily inspired from;
    # https://codeberg.org/heygarrett/.config/fish/functions/git.fish
    if not status --is-interactive
        command git $argv
        return
    end

    if contains -- checkout $argv; or contains -- switch $argv
        if command -q git rev-parse --git-dir >/dev/null 2>&1
            command git show-ref --quiet refs/heads/master
            set --local master_exists (test $status -eq 0; and echo 1; or echo 0)
        else
            set --local master_exists 0
        end

        if contains -- -b $argv; or contains -- -B $argv
            # -b/-B

            set --local create_flag_index (contains --index -- "-b" $argv); or set create_flag_index (contains --index -- "-B" $argv)
            set --local branch_name $argv[(math $create_flag_index + 1)]

            if test "$branch_name" = master; and test $master_exists -eq 0
                echo "Warning: Creating branches named 'master' is discouraged. Consider using 'main' instead."
                set --local prompt "Would you like to create 'main' instead? [Y/n] "
                while read --local --prompt-str $prompt response; or return 1
                    switch $response
                        case y Y ""
                            set argv[(math $create_flag_index + 1)] main
                            break
                        case n N
                            return 1
                    end
                end
            end

        else if contains -- master $argv; and test $master_exists -eq 0
            # checkout/switch

            echo "Warning: Creating branches named 'master' is discouraged. Consider using 'main' instead."
            set --local prompt "Would you like to checkout 'main' instead? [Y/n] "
            while read --local --prompt-str $prompt response; or return 1
                switch $response
                    case y Y ""
                        set --local master_index (contains --index -- "master" $argv)
                        set argv[$master_index] main
                        break
                    case n N
                        return 1
                end
            end
        end
    end

    command git $argv
end

function git --wraps "git"
    # NOTE: Heavily inspired from;
    # https://codeberg.org/heygarrett/.config/src/branch/main/fish/functions/git.fish

    if not status --is-interactive
        command git $argv
        return
    end

    if contains -- checkout $argv; or contains -- switch $argv
        # checkout -b/-B
        if contains -- -b $argv; or contains -- -B $argv
            set --local create_flag_index (contains --index -- "-b" $argv); or set create_flag_index (contains --index -- "-B" $argv)
            set --local branch_name $argv[(math $create_flag_index + 1)]

            if test "$branch_name" = "master"
                echo "Warning: Creating branches named 'master' is discouraged. Consider using 'main' instead."
                set --local prompt "Would you like to create 'main' instead? [Y/n] "
                while read --local --prompt-str $prompt response; or return 1
                    switch $response
                        case y Y ""
                            set argv[(math $create_flag_index + 1)] "main"
                            break
                        case n N
                            return 1
                    end
                end
            end
        # checkout
        else if contains -- master $argv
            echo "Warning: Checking out 'master' is discouraged. Consider using 'main' instead."
            set --local prompt "Would you like to checkout 'main' instead? [Y/n] "
            while read --local --prompt-str $prompt response; or return 1
                switch $response
                    case y Y ""
                        set --local master_index (contains --index -- "master" $argv)
                        set argv[$master_index] "main"
                        break
                    case n N
                        return 1
                end
            end
        end
    end

    command git $argv
end

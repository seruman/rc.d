function git-forgit --wraps=git-forgit
    if not status --is-interactive
        command git-forgit $argv
        return
    end

    command git show-ref --quiet refs/heads/master
    set --local master_exists (test $status -eq 0; and echo 1; or echo 0)

    if test "$argv[1]" = checkout_branch; and test "$argv[2]" = master; and test $master_exists -eq 0
        echo "Warning: Creating branches named 'master' is discouraged. Consider using 'main' instead."
        set --local prompt "Would you like to checkout 'main' instead? [Y/n] "
        while read --local --prompt-str $prompt response; or return 1
            switch $response
                case y Y ""
                    command git-forgit checkout_branch main
                    return
                case n N
                    command git-forgit checkout_branch master
                    return
            end
        end
    else
        command git-forgit $argv
    end
end

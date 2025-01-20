function git-forgit --wraps "git-forgit"
    if not status --is-interactive
        command git-forgit $argv
        return
    end

    if test "$argv[1]" = "checkout_branch"; and test "$argv[2]" = "master"
        echo "Warning: Checking out 'master' is discouraged. Consider using 'main' instead."
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
        # Pass through all git-forgit commands unchanged
        command git-forgit $argv
    end
end

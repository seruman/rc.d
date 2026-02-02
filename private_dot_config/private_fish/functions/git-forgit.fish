function git-forgit --wraps=git-forgit
    if not status is-interactive
        command git-forgit $argv
        return
    end

    set -l i (__git_should_suggest_main "checkout_branch" $argv)
    if test $status -eq 0
        echo "git: 'master' branch doesn't exist, did you mean 'main'?"
        read -l -P "Use 'main' instead? [Y/n] " response
        switch $response
            case y Y ""
                set argv[$i] main
        end
    end

    command git-forgit $argv
end

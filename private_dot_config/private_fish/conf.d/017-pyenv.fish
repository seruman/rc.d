if not command -sq pyenv
    return
end

set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

set -l pyenv_completion_file
if command -sq brew
    set pyenv_completion_file (brew --prefix pyenv)/completions/pyenv.fish
end

fish_add_path $PYENV_ROOT/shims
set -gx PYENV_SHELL fish

if test -f $pyenv_completion_file
    source $pyenv_completion_file
end

command pyenv rehash 2>/dev/null
function pyenv
    set command $argv[1]
    set -e argv[1]

    switch "$command"
        case rehash shell
            source (pyenv "sh-$command" $argv|psub)
        case '*'
            command pyenv "$command" $argv
    end
end

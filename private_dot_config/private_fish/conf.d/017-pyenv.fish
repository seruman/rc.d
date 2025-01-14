set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

# TODO:
while set pyenv_index (contains -i -- "/Users/selman/.pyenv/shims" $PATH)
    set -eg PATH[$pyenv_index]
end
set -e pyenv_index

#set -gx PATH '/Users/selman/.pyenv/shims' $PATH
fish_add_path /Users/selman/.pyenv/shims
set -gx PYENV_SHELL fish
source '/opt/homebrew/Cellar/pyenv/2.4.13/libexec/../completions/pyenv.fish'
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

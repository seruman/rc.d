function k9s --wraps 'k9s'
    set -lx TERM xterm-256color
    command k9s $argv
end

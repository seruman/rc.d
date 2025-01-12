function fish_user_key_bindings
    set -g fish_sequence_key_delay_ms 300

    bind \cx\ce edit_command_buffery
    bind \cl\ct __fish_git_semtag
end

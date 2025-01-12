set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_CACHE_HOME; or set -gx XDG_CACHE_HOME $HOME/.cache
set -q XDG_DATA_HOME; or set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_STATE_HOME; or set -gx XDG_STATE_HOME $HOME/.local/state
set -q XDG_RUNTIME_DIR; or set -gx XDG_RUNTIME_DIR $HOME/.xdg

for xdgdir in $XDG_CONFIG_HOME $XDG_CACHE_HOME $XDG_DATA_HOME $XDG_STATE_HOME $XDG_RUNTIME_DIR
    test -e $xdgdir; or mkdir -p $xdgdir
end

if status is-interactive
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_showdirtystate 'yes'
    set -g __fish_git_prompt_char_stateseparator ' '
    set -g __fish_git_prompt_char_dirtystate "✖"
    set -g __fish_git_prompt_char_cleanstate "✔"
    set -g __fish_git_prompt_char_untrackedfiles "…"
    set -g __fish_git_prompt_char_stagedstate "●"
    set -g __fish_git_prompt_char_conflictedstate "+"
    set -g __fish_git_prompt_color_dirtystate yellow
    set -g __fish_git_prompt_color_cleanstate green --bold
    set -g __fish_git_prompt_color_invalidstate red
    set -g __fish_git_prompt_color_branch cyan --dim --italics

    set fish_autosuggestion_enabled 0
    set -g fish_color_search_match normal
end

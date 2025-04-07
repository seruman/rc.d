if status is-interactive
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_showdirtystate yes
    set -g __fish_git_prompt_char_stateseparator ' '
    set -g __fish_git_prompt_char_dirtystate "✖"
    set -g __fish_git_prompt_char_cleanstate "✔"
    set -g __fish_git_prompt_char_untrackedfiles "…"
    set -g __fish_git_prompt_char_stagedstate "●"
    set -g __fish_git_prompt_char_conflictedstate "+"
    set -g __fish_git_prompt_color_dirtystate yellow
    set -g __fish_git_prompt_color_cleanstate green --bold
    set -g __fish_git_prompt_color_invalidstate red
    set -g __fish_git_prompt_color_branch black --italics

    set fish_autosuggestion_enabled 0
    set -g fish_color_search_match normal
end

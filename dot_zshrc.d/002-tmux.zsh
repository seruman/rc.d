if [ -z "$TMUX" ]; then
    return
fi


chpwd_functions+=()
function get_tmux_window_name {
    if [ ! -x "$(command -v ghq)" ]; then
        return
    fi

    local ghq_roots=($(ghq root --all))
    local in_ghq_root=false
    for root in "${ghq_roots[@]}"; do
        if [[ "$PWD" == "$root"* ]]; then
            in_ghq_root=true
            break
        fi
    done

    local shortened_path
    if [[ $in_ghq_root == true ]]; then
        local pathtorepo

        for root in "${ghq_roots[@]}"; do
            pathtorepo="${PWD#$root/}"
        done

        local path_array=(${(s:/:)pathtorepo})
        if (( ${#path_array[@]} > 1 )); then
            shortened_path="${path_array[-2]}/${path_array[-1]}"
        else
            shortened_path="${path_array[-1]}"
        fi
    else
        local base_dir="${PWD##*/}"  # Base directory name
        local parent_path="${PWD%/*}"  # Get the parent path excluding the base directory
        parent_path="${parent_path/$HOME/~}"  # Replace $HOME with ~
        shortened_path=$(echo "$parent_path" | sed -E 's|/([^/])[^/]*|/\1|g')
        shortened_path="${shortened_path}/${base_dir}"  # Append the base directory
    fi

    echo "$shortened_path"
}

function update_tmux_window_name {
    local is_old_git_repo=false
    local is_git_repo=false

    if [ -n "$OLDPWD" ] && git -C "$OLDPWD" rev-parse --is-inside-work-tree &>/dev/null; then
        is_old_git_repo=true
    fi

    if git rev-parse --is-inside-work-tree &>/dev/null; then
        is_git_repo=true
    fi

    if [ "$is_old_git_repo" = true ] && [ "$is_git_repo" = false ]; then
        tmux set-window-option automatic-rename on
        return
    fi

    if [ "$is_git_repo" = true ]; then
        local window_name
        window_name=$(get_tmux_window_name)
        tmux rename-window "$window_name"
    fi
}

chpwd_functions+=update_tmux_window_name

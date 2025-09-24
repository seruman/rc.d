if not status is-interactive
    return
end

if not command -q shpool
    return
end

set -l config_dir "$HOME/.config/shpool"
set -l app_support_dir "$HOME/Library/Application Support/shpool"
set -l app_support_config "$app_support_dir/config.toml"

if not test -d "$config_dir"
    return
end

if not test -d "$app_support_dir"
    mkdir -p "$app_support_dir"
end

if not test -e "$app_support_config"
    ln -s "$config_dir/config.toml" "$app_support_config"
    return
end

if not test -L "$app_support_config"
    return
end

set -l link_target (readlink "$app_support_config")
if test "$link_target" \!= "$config_dir/config.toml"
    # Points somewhere else, don't touch it
    return
end

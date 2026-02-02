# TODO: Maybe configure fisher to work in its own directory?

set -l current_dir (status dirname)
set -l plugins_dir $current_dir/../plugins

for plugin in $plugins_dir/*
    if not test -d $plugin
        continue
    end

    # if has functions, add to fish_function_path
    if test -d $plugin/functions
        set -g fish_function_path $fish_function_path $plugin/functions
    end

    if test -d $plugin/completions
        set -g fish_complete_path $fish_complete_path $plugin/completions
    end

    if test -d $plugin/conf.d
        for conf in $plugin/conf.d/*
            source $conf
        end
    end
end

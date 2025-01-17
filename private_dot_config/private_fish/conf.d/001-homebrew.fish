for p in /opt/homebrew/bin /opt/homebrew/sbin
    test -d $p; and fish_add_path -g $p
end

if command -sq brew
    set -l brew_cache $XDG_CACHE_HOME/fish/homebrew.fish

    # Create cache directory
    mkdir -p (dirname "$brew_cache")

    # Cache brew shellenv output if not exists
    if not test -f $brew_cache
        brew shellenv > $brew_cache
    end

    source $brew_cache

    set -xU HOMEBREW_NO_ANALYTICS 1
    set -xU HOMEBREW_NO_AUTO_UPDATE 1
end

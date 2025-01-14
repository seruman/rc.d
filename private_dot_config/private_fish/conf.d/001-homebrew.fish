for p in /opt/homebrew/bin /opt/homebrew/sbin
    test -d $p; and fish_add_path -U $p
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

    # Homebrew preferences
    set -U HOMEBREW_NO_ANALYTICS 1
    set -U HOMEBREW_NO_AUTO_UPDATE 1
end

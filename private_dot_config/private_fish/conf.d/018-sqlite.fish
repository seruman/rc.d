if set -q HOMEBREW_PREFIX
    set -l sqlite_prefix $HOMEBREW_PREFIX/opt/sqlite
    if test -d $sqlite_prefix
        fish_add_path -g $sqlite_prefix/bin
    end
end

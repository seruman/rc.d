if command -sq brew
    set -l sqlite_prefix (brew --prefix sqlite)

    fish_add_path -g -g $sqlite_prefix/bin
end

if command -sq brew
    set -l sqlite_prefix (brew --prefix sqlite)

    fish_add_path -g $sqlite_prefix/bin
end

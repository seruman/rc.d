set -l hare_dir "$HOME/.hare"
if test -d $hare_dir
    for p in $hare_dir/bin
        fish_add_path $p
        set -x MANPATH $MANPATH $hare_dir/share/man
    end
end

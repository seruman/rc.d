for p in $HOME/.local/bin/ $HOME/bin $HOME/sbin
    test -d $p; and fish_add_path -m $p
end
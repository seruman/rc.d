set -l bob_dir "$HOME/.local/share/bob"
if test -d $bob_dir
    for p in $bob_dir/nvim-bin
        fish_add_path $p
    end
end

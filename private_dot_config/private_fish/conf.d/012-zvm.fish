set -l zvm_dir "$HOME/.zvm"
if test -d $zvm_dir
    for p in $zvm_dir/self $zvm_dir/bin
        fish_add_path -g $p
    end
end

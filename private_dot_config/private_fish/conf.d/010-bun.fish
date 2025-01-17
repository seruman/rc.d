set -l bun_dir "$HOME/.bun"
if test -d $bun_dir
    set -gx BUN_INSTALL $bun_dir
    fish_add_path -g $bun_dir/bin
end

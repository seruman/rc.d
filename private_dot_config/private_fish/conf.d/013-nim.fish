set -l nimble_dir "$HOME/.nimble/bin"
if test -d $nimble_dir
    fish_add_path -g $nimble_dir
end

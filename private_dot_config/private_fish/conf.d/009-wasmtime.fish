set -l wasmtime_home "$HOME/.wasmtime"
if test -d $wasmtime_home
    fish_add_path -g $wasmtime_home/bin
    set -gx WASMTIME_HOME $wasmtime_home
end

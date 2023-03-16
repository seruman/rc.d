# vi: ft=zsh

alias ghqf='cd $(ghq list | fzf | xargs -I{} echo $(ghq root)/{})'

# Git
alias gr='cd `git root`'



# OpenScad: macOS
if [[ "$OS" == "Darwin" ]]; then
    local openscad_dir="/Applications/OpenSCAD.app/Contents/MacOS"
    if [[ ! -f "$openscad_dir" ]]; then :; fi

    alias openscad="$openscad_dir/OpenSCAD"
fi  

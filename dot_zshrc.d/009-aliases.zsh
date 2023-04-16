# vi: ft=zsh

function ghqf() {
    # TODO(selman): gum is unnecessary IMHO. 
    local previewcmd="
    gum format -t template '{{ Bold \"{}\" }}';
    git -C \$(ghq list --full-path -e {}) remote get-url \$(git -C \$(ghq list --full-path -e {}) remote);
    ls --color=always \$(ghq list --full-path -e {});
    "
    local repopath=$(
        ghq list |
            fzf \
                --prompt 'Repositories> ' \
                --preview "${previewcmd}" \
                --query "${*:-}" |
            xargs -I{} ghq list --full-path -e {}
    )

    if [ -n "$repopath" ]; then
        cd "$repopath"
    fi
}

# Git
alias gr='cd `git root`'

# OpenScad: macOS
if [[ "$OS" == "Darwin" ]]; then
    local openscad_dir="/Applications/OpenSCAD.app/Contents/MacOS"
    if [[ ! -f "$openscad_dir" ]]; then :; fi

    alias openscad="$openscad_dir/OpenSCAD"
fi

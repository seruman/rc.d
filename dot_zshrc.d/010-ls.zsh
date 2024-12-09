# vi: ft=zsh

if $(command -v dircolors >/dev/null 2>&1); then
    eval $(dircolors)
elif $(command -v gdircolors >/dev/null 2>&1); then
    eval $(gdircolors)
fi

export CLICOLOR=1

alias ls='ls --color=auto'

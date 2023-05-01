# vi: ft=zsh

if $(command -v dircolors >/dev/null 2>&1); then
	eval $(dircolors)
else
	export CLICOLOR=1
fi

alias ls='ls --color=auto'

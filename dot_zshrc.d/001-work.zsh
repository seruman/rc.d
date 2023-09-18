# vi: ft=zsh

export _WORK_DOTFILES=$XDG_CONFIG_HOME/work

[[ -d $_WORK_DOTFILES ]] || return 0

[[ -f $_WORK_DOTFILES/init.zsh ]] && source $_WORK_DOTFILES/init.zsh

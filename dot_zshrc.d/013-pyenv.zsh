# vi: ft=zsh

if [[ -n "$(command -v pyenv)" ]]; then
	export PYENV_ROOT="$HOME/.pyenv"
	path=(
		"$PYENV_ROOT/bin"
		$path
	)

	eval "$(pyenv init -)"
fi

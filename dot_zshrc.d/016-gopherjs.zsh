# vi: ft=zsh

[[ -x "$(command -v go1.18.6)" ]] && export GOPHERJS_GOROOT="$(go1.18.6 env GOROOT)"

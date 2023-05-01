# vi: ft=zsh

function generate-envrc-venv {
	local python_version="${1:-python3}"
	local venv_path="${2:-.venv}"

	cat <<EOF
# vim: ft=sh
export VIRTUAL_ENV="${venv_path}"
layout python "$python_version"
EOF

}

function generate-ignore-venv() {
	local venv_path=$(basename "${VIRTUAL_ENV:-.venv}")
	echo "${venv_path}/"
}

local docker_config=${DOCKER_CONFIG:-$HOME/.docker}
local docker_cli_plugins=${docker_config}/cli-plugins


if [ ! -d "$docker_cli_plugins" ]; then
    mkdir -p "$docker_cli_plugins"
fi

if [[ "$OS" == "Darwin" ]]; then
    if [[ "$(command -v brew)" == "" ]]; then
        return
    fi

    local compose_bin="$(brew --prefix docker-compose)/bin/docker-compose"

    if [[ ! -f "$compose_bin" ]]; then
        return
    fi

    ln -sfn "$(brew --prefix docker-compose)/bin/docker-compose" "${docker_cli_plugins}/docker-compose"
fi

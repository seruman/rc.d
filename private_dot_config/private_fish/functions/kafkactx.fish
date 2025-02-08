function kafkactx --description 'Switch kafkactl context'
    if not command -sq kafkactl
        return 0
    end

    # Handle subcommands
    switch "$argv[1]"
        case bootstrap-servers
            __kafkactx_brokeraddr
        case ''
            __kafkactx_switch_context
        case '*'  # Handle unknown subcommands
            echo "Unknown subcommand: $argv[1]" >&2
            return 1
    end
end


function __kafkactx_switch_context
    set -l contexts (kafkactl config get-contexts -o compact | grep -v 'default' | sort)
    set -l current_context (kafkactl config current-context)
    if test -n "$current_context"
        set contexts (string replace $current_context (set_color yellow)$current_context(set_color normal) $contexts)
    end
    # TODO: \n join might not be needed.
    set -l selection (string join \n $contexts | fzf --ansi --prompt="Kafkactx> ")
    if test -z "$selection"
        return 0
    end
    kafkactl config use-context $selection
end

function __kafkactx_brokeraddr
    if not command -sq yq
        echo "yq is required" >&2
        return 1
    end

    set -l current_context (kafkactl config current-context)

    set -l bootstrap_servers (kafkactl config view | yq '.contexts."'$current_context'".brokers | join(",")')

    echo $bootstrap_servers
end

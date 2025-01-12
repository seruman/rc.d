function kafkactx --description 'Switch kafkactl context'
    if not command -sq kafkactl
        return 0
    end

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

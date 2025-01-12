function kafctx --description 'Switch Kafka context using kaf CLI'
    if not command -sq kaf
        return 0
    end

    kaf config select-cluster
end

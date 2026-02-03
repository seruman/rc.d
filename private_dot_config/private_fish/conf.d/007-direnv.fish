if command -sq direnv
    cashfish --ttl=168h -- direnv hook fish | source
end

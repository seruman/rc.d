if not status is-interactive
    return
end

if command -sq ht
    cashfish --ttl=168h -- ht completion fish | source
end

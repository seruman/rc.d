if command -sq zoxide
    cashfish --ttl=168h -- zoxide init fish --cmd j | source
end

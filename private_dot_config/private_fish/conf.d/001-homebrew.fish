set -l brew_path
if test -x /opt/homebrew/bin/brew
    set brew_path /opt/homebrew/bin/brew
else if test -x /usr/local/bin/brew
    set brew_path /usr/local/bin/brew
end

if test -n "$brew_path"
    cashfish --ttl=48h -- $brew_path shellenv | source

    set -gx HOMEBREW_NO_ANALYTICS 1
    set -gx HOMEBREW_NO_AUTO_UPDATE 1
end

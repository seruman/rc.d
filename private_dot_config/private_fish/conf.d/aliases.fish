# ~/.config/fish/conf.d/aliases.fish

# git
alias gr='cd (git rev-parse --show-toplevel)'

# docker-compose
alias dc="docker compose"

# go
## gotest
alias got="gotest -v"
alias gota="gotest -v ./..."
alias gotai="gotest -v ./... -tags=integration"
alias gotanc="gotest -v ./... -count=1"
alias gotaf="gotest ./... -count=1 -run=(rg 'func (Test.+)\(' (find . -type f -name '*.go' -not -path './vendor/*') -NIo --no-heading -r '\$1' | fzf)"

## gotestsum
alias gots="gotestsum"
alias gotsa="gotestsum -- ./..."
alias gotsai="gotestsum -- ./... -tags=integration"
alias gotsanc="gotestsum -- ./... -count=1"
alias gotsaf="gotestsum -- ./... -count=1 -run=(rg 'func (Test.+)\(' (find . -type f -name '*.go' -not -path './vendor/*') -NIo --no-heading -r '\$1' | fzf)"

## goimports
alias goil="goimports -l (find . -type f -name '*.go' -not -path './vendor/*')"
alias goid="goimports -d (find . -type f -name '*.go' -not -path './vendor/*') | colordiff"
alias goiw="goimports -w (find . -type f -name '*.go' -not -path './vendor/*')"

# github
alias ghprls="gh pr list"
alias ghprlsf="set -lx GH_FORCE_TTY yes; gh pr list | fzf --ansi --header-lines 4 --preview 'GH_FORCE_TTY=yes gh pr view {1}' | awk '{print \$1}' | xargs -I {} gh pr view --web {}"
alias ghprcof="set -lx GH_FORCE_TTY yes; gh pr list | fzf --ansi --header-lines 4 --preview 'GH_FORCE_TTY=yes gh pr view {1}' | awk '{print \$1}' | xargs -I {} gh pr checkout {}"
alias ghprmk="gh pr create"

# ripgrep
alias rgnoi="rg --no-ignore"

# unixtime
alias ute="unixtime encode"
alias utd="unixtime decode"

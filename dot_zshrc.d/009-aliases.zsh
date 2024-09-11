# vi: ft=zsh

# git
alias gr='cd `git root`'

# docker-compose
alias dc="docker compose"

# go
#
## gotest
alias got="gotest -v"
alias gota="gotest -v ./..."
alias gotai="gotest -v ./... -tags=integration"
alias gotanc="gotest -v ./... -count=1"
alias gotaf="gotest ./... -count=1 -run=\$(rg 'func (Test.+)\(' \$(find . -type f -name '*.go' -not -path './vendor/*') -NIo --no-heading -r '\$1'| fzf)"

## gotestsum
alias gots="gotestsum"
alias gotsa="gotestsum -- ./..."
alias gotsai="gotestsum -- ./... -tags=integration"
alias gotsanc="gotestsum -- ./... -count=1"
alias gotsaf="gotestsum --  ./... -count=1 -run=\$(rg 'func (Test.+)\(' \$(find . -type f -name '*.go' -not -path './vendor/*') -NIo --no-heading -r '\$1'| fzf)"

## goimports
alias goil="goimports -l \$(find . -type f -name '*.go' -not -path './vendor/*')"
alias goid="goimports -d \$(find . -type f -name '*.go' -not -path './vendor/*') | colordiff"
alias goiw="goimports -w \$(find . -type f -name '*.go' -not -path './vendor/*')"

# github
alias ghprls="gh pr list"
alias ghprlsf="GH_FORCE_TTY=yes gh pr list | fzf --ansi --header-lines 4 --preview 'GH_FORCE_TTY=yes gh pr view  {1}' | awk '{ print \$1}' | xargs -I {} gh pr view --web {}"
alias ghprcof="GH_FORCE_TTY=yes gh pr list | fzf --ansi --header-lines 4 --preview 'GH_FORCE_TTY=yes gh pr view  {1}' | awk '{ print \$1}' | xargs -I {} gh pr checkout {}"
alias ghprmk="gh pr create"

# ripgrep
alias rgnoi="rg --no-ignore"

# URL encode/decode
alias urldecode='python2 -c "import sys, urllib as ul; \
    print ul.unquote_plus(sys.stdin.read())"'
alias urlencode='python2 -c "import sys, urllib as ul; \
    print ul.quote_plus(sys.stdin.read())"'

# unixtime
alias ute="unixtime encode"
alias utd="unixtime decode"

# OpenScad: macOS
if [[ "$OS" == "Darwin" ]]; then
    local openscad_dir="/Applications/OpenSCAD.app/Contents/MacOS"
    if [[ ! -f "$openscad_dir" ]]; then :; fi

    alias openscad="$openscad_dir/OpenSCAD"
fi

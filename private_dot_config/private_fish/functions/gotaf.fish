function _gotaf_cmd -a pkgs -a tags
    if test -z "$pkgs"
        set pkgs ./...
    end

    set -l format "{{.Package}}:{{.FullName}}:{{.RelativeFileName}}:{{.Range.Start.Line}}:{{.Range.End.Line}}"
    set -l lines ( listests --format="$format" -tags=$tags $pkgs | fzf --delimiter : \
        --multi \
        --preview 'echo $FZF_COLUMNS; bat --style=full --color=always --terminal-width $FZF_COLUMNS --highlight-line {4}:{5} {3}' \
        --preview-window '70%,~4,+{4}+4/4' \
        --height 60%
    )
    if test -z "$lines"
        return 0
    end

    set -l tests
    set -l packages
    for line in $lines
        set -l testname ( echo $line | cut -d : -f 2 )
        set -l pkg ( echo $line | cut -d : -f 1 )
        set tests $tests $testname
        set packages $packages "./$pkg"
    end

    set packages ( printf '%s\n' $packages | sort -u )

    set -l cmd "gotest -v -tags=\"$tags\" $(string join ' ' $packages) -count=1 -run=\"$(string join '|' $tests)\""
    echo $cmd
end

function gotaf -a pkgs -a tags
    set -l cmd ( _gotaf_cmd $pkgs $tags )
    if test -n "$cmd"
        echo $cmd
        history append -- $cmd
        eval $cmd
    end
end

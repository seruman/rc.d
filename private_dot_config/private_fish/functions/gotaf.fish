function _gotaf_cmd -a pkgs -a tags
    if test -z "$pkgs"
        set pkgs ./...
    end

    set -l format "{{.RelativeFileName}}:{{.Range.Start.Line}}:{{.Range.End.Line}}:{{.FullName}}"
    set -l lines ( listests --format="$format" -tags=$tags $pkgs | fzf --delimiter : \
        --multi \
        --preview 'echo $FZF_COLUMNS; bat --style=full --color=always --terminal-width $FZF_COLUMNS --highlight-line {2}:{3} {1}' \
        --preview-window '70%,~4,+{2}+4/4' \
        --height 60%
    )
    if test -z "$lines"
        return 0
    end

    set -l tests
    for line in $lines
        set -l testname ( echo $line | cut -d : -f 4 )
        set tests $tests $testname
    end

    set -l cmd "gotest -v -tags=\"$tags\" ./... -count=1 -run=\"$(string join '|' $tests)\""
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

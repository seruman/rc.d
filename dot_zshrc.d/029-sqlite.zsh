if [[ "$OS" == "Darwin" ]]; then
    if [[ -n $(command -v brew) ]]; then
        local sqlite_prefix="$(brew --prefix sqlite)"
        path=(
            "${sqlite_prefix}/bin"
            $path
        )

        # export LDFLAGS="-L${sqlite_prefix}/lib"
        # export CPPFLAGS="-I${sqlite_prefix}/include"
    fi
        
fi

# vi: ft=zsh

case $(uname) in
    Darwin)    OS=Darwin  ;;
    *)         OS=Linux   ;;
esac

if [[ "$OS" == "Darwin" ]]; then
    __seruman::source_rc_files "${ZSHRCD}./~darwin.d"
elif [ "$OS" == "Linux" ]; then
    __seruman::source_rc_files "${ZSHRCD}./~linux.d"
fi

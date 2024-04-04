# vi: ft=zsh

case $(uname) in
    Darwin)    OS=Darwin  ;;
    *)         OS=Linux   ;;
esac

# Light background, dark foreground.
export COLORFGBG="0;15"

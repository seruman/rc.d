# vi: ft=zsh

for confdir in ${ZSHRCD}/*(.)d(N); do
    case ${confdir:t} in '~'*) continue;; esac
    seruman::source_rc_files "$confdir"
done

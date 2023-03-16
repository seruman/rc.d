# vi: ft=zsh

for confdir in ${ZSHRCD}/*(.)d(N); do
    case ${confdir:t} in '~'*) continue;; esac
    __seruman::source_rc_files "$confdir"
done

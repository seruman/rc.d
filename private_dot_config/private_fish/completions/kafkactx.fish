complete -c kafkactx -f # -f prevents file completion

complete -c kafkactx -n "__fish_use_subcommand" -a bootstrap-servers -d "Comma separated broker addresses"

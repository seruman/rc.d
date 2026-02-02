status is-interactive; or return

if not command -sq git-forgit
    return
end


abbr -a -- ga git-forgit add
abbr -a -- grh git-forgit reset_head
abbr -a -- glo git-forgit log
abbr -a -- grl git-forgit reflog
abbr -a -- gd git-forgit diff
abbr -a -- gcf git-forgit checkout_file
abbr -a -- gcb git-forgit checkout_branch
abbr -a -- gbd git-forgit branch_delete
abbr -a -- gclean git-forgit clean
abbr -a -- gss git-forgit stash_show
abbr -a -- gsp git-forgit stash_push
abbr -a -- gcp git-forgit cherry_pick_from_branch
abbr -a -- grb git-forgit rebase
abbr -a -- gfu git-forgit fixup
abbr -a -- gco git-forgit checkout_commit
abbr -a -- grc git-forgit revert_commit
abbr -a -- gbl git-forgit blame
abbr -a -- gct git-forgit checkout_tag
#abbr -a -- gi git-forgit ignore

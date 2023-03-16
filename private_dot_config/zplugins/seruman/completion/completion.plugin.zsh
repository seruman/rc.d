# NOTE(selman): Slighly modified version mattmc3/zephyr/plugins/completion;
# - https://github.com/mattmc3/zephyr/blob/main/plugins/completion/completion.plugin.zsh
# With customs styles.

fpath=(${0:A:h}/functions $fpath)
autoload -z $fpath[1]/*(.:t)

fpath=(${0:A:h}/completions(-/FN) $fpath)

if [[ $OSTYPE == darwin* ]]; then
    fpath=(
      # add curl completions from homebrew if they exist
      /{usr,opt}/{local,homebrew}/opt/curl/share/zsh/site-functions(-/FN)

      # add zsh completions
      /{usr,opt}/{local,homebrew}/share/zsh/site-functions(-/FN)

      # Allow user completions.
      ${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}/completions(-/FN)

      # rest of fpath
      $fpath
    )
fi

run-compinit
set-completion-styles

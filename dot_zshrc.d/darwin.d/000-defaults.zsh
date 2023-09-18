# vi: ft=zsh

if [[ "$OS" != "Darwin" ]]; then
  return
fi

# TODO(selman): some how cache this and only run if needed.

defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)


# TODO(selman): https://wilsonmar.github.io/dotfiles/
# TODO(selman): https://github.com/mathiasbynens/dotfiles/blob/main/.macos
# TODO(selman): https://raw.githubusercontent.com/rusty1s/dotfiles/master/macos/defaults.sh
defaults write com.apple.Finder QuitMenuItem 1
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder FXPreferredViewStyle clmv
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

defaults write com.apple.screencapture location -string "${HOME}/etc/screenshots"

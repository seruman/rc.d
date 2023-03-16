defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)


# TODO(selman): https://wilsonmar.github.io/dotfiles/
# TODO(selman): https://github.com/mathiasbynens/dotfiles/blob/main/.macos
defaults write com.apple.Finder QuitMenuItem 1
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true

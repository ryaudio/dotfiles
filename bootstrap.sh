#!/bin/bash
# Make sure the user's sudo is recent
sudo -v
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  # Linux
  sudo apt update
  sudo apt install zsh tmux htop tree git make cmake gcc ssh curl wget awk pv rsync -y --ignore-missing
  sudo apt install vim-gtk -y
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX
  xcode-select --install 2> /dev/null
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
  brew install zsh tmux htop tree git make cmake gcc curl wget pv rsync awk
  brew cask install iterm2
  
  # make sure home and end work universally
  mkdir -p ~/Library/KeyBindings/
  echo '{"\UF729"  = "moveToBeginningOfLine:";"\UF72B"  = "moveToEndOfLine:";"$\UF729" = "moveToBeginningOfLineAndModifySelection:";"$\UF72B" = "moveToEndOfLineAndModifySelection:";}' > ~/Library/KeyBindings/DefaultKeyBinding.dict
  # in iTerm2 set "send escape sequence" plus the following for each key respectively:
  # LEFT_1_WORD: b  RIGHT_1_WORD: f
  
  # Also be sure to install the colortheme and the font that you want!
else
  # What is this?
  echo "Unknown os"
  exit
fi

# Oh-my-zsh
curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh

# powerlevel9k theme for zsh
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# zsh syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Zsh Completions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

# Zsh Suggestions while typing
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

sudo chsh -s $(which zsh) $USER

echo "Configuration done! You probably still want to configure git and ssh."

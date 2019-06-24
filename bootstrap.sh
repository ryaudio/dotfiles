#!/bin/bash
# Make sure the user's sudo is recent
sudo -v
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  # Linux
  sudo apt update && sudo apt upgrade -y
  sudo apt install zsh tmux htop tree git make cmake gcc ssh curl wget awk pv rsync watch cmatrix -y --ignore-missing
  sudo apt install vim-gtk -y
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX
  xcode-select --install 2> /dev/null
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
  brew update && brew upgrade
  brew install zsh tmux htop tree git make cmake gcc curl wget pv rsync awk watch cmatrix
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
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh) --unattended"

# Move the .zshrc back after oh-my-zsh changes it
mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc
# powerlevel9k theme for zsh
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# zsh syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Zsh Completions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

# Zsh Suggestions while typing
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

sudo chsh -s $(which zsh) $USER

# Install fonts for powerline
# Note: still need to select them as default on mac
git clone https://github.com/powerline/fonts
cd fonts
sh install.sh
cd ..
rm -rf fonts

# Install TMUX Package Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Make tmux install the plugins, without us having to hit prefix + I
tmux new-session -d -s plugin_install 'sleep 1; ~/.tmux/plugins/tpm/bindings/install_plugins'

echo ""
echo ""
echo "Configuration done! You probably still want to configure git and ssh."
echo "Make sure to select the \"Meslo LG M Regular for Powerline\" font in your terminal!"

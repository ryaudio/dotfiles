#!/bin/bash
# Make sure the user's sudo is recent
sudo -v

packagelist=(
  zsh     # A much better shell than the default bash!  
  tmux    # A great terminal multiplexer. Allows disconnecting from ssh session and reconnecting later, as well as splitting terminal windows and more
  htop    # An easy to use tool to view CPU and memory usage stats
  tree    # Gives a filesystem tree representation
  git     # Used for version controling software. Also needed by the bootstrap.sh script to install software
  make
  cmake
  gcc
  curl    # Used to issue http requests as well as get items from the web
  wget    # Simpler tool to get files from the web
  pv      # Used to display progress of reading a file. Great for showing progress of long commands.
  rsync   # Efficient way to copy files as well as keep them in sync with eachother.
  watch   # Repeatedly calls command. Great when used in conjunction with nvidia-smi to watch GPU stats.
  git-lfs # Extension for git that manages big files better. Note that this still has to be activated for each git repo you want to use it in!
  xclip   # Needed for copying from tmux to system clipboard
  cmatrix # Cool matrix effect as a placeholder, nice with tmux
)

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  # Linux
  sudo apt update && sudo apt upgrade -y
  sudo apt install -y --ignore-missing ${packagelist[@]}
  sudo apt install python3-dev python-dev vim-gtk ssh -y
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX
  xcode-select --install 2> /dev/null
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
  brew update && brew upgrade
  brew install ${packagelist[@]}
  brew install openssh
  brew cask install iterm2
  
  # ensure that sshd is enabled
  sudo systemsetup -setremotelogin on

  # mac installs BSD tar which is incompatible with GNU tar. Use GNU instead
  brew install gnu-tar
  sudo unlink `which tar`
  sudo ln -s `which gtar` /usr/bin/tar

  # make finder show hidden files
  defaults write com.apple.Finder AppleShowAllFiles true
  
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
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  mkdir -p ~/.local/share/fonts
  cd ~/.local/share/fonts 
elif [[ "$OSTYPE" == "darwin"* ]]; then
  cd ~/Library/Fonts
else
  # What is this?
  echo "Unknown os"
  exit
fi
# Install the font in the fonts directory
curl -fLo "Meslo LG M Regular Nerd Font Complete Mono.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Meslo/M/Regular/complete/Meslo%20LG%20M%20Regular%20Nerd%20Font%20Complete%20Mono.ttf?raw=true
# Return to last directory
cd -

# Install TMUX Package Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Make tmux install the plugins, without us having to hit prefix + I
tmux new-session -d -s plugin_install 'sleep 1; ~/.tmux/plugins/tpm/bindings/install_plugins'

# Run Vim-Plug's PlugInstall command to install plugins for the first time
# https://github.com/junegunn/vim-plug/issues/675#issuecomment-328157169
vim +'PlugInstall --sync' +qa

echo ""
echo ""
echo "Configuration done! You probably still want to configure git and ssh."
echo "Make sure to select the \"Meslo LG M Regular Nerd Font Complete Mono.ttf\" font in your terminal!"

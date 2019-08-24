# Dotfiles
A collection of the dotfiles to use and scripts to get you up and running fast on debian or mac based operating systems.

## Installation steps:
1. Clone this repo and make sure all the files are located in your home folder
2. Run `bash bootstrap.sh` to perform the first-time setup. 
It will prompt you once or twice during the setup, and will take several minutes if this is the first time the computer has been updated in a while.
3. Install the [Meslo LG M Regular Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Meslo/M/Regular/complete). 
Set it as the font for your terminal.
4. [Optional] Set your terminal to use the Monokai Vivid or Remastered colors file. 
If on windows and using WSL, use the [Windows ColorTool](https://devblogs.microsoft.com/commandline/introducing-the-windows-console-colortool/) to configure the terminal to use the file's colors.
5. Delete `README.md`, `bootstrap.sh`, and `Monokai Remastered.itermcolors`.
6. Enjoy your fancy new terminal!

## Features
* Zsh as the shell of choice
* Oh-My-Zsh as a nifty set of extensions to Zsh
* Powerlevel9k as a beautiful theme for Zsh
* Updates your packages automatically so you don't have to do it yourself
* Provides a number of nice plugins for tmux and vim
* Installs many commonly used tools needed for software development
* Deals with common setup issues in tmux, such as colors being limited over ssh.
* Includes a number of useful utilities for displaying the progress of copying and [un]compressing files.
* Much much more!

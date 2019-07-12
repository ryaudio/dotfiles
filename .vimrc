set number
syntax on
set hlsearch

" Fix the weird issue where the delete button on mac doesn't backspace sometimes
set backspace=indent,eol,start

" yank to clipboard
set clipboard=unnamed

" Tabs and spaces
set tabstop=2
set shiftwidth=2
set expandtab


" Install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify directory for plugins
" Avoid using standard ones like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes!

" Initialize plugin system
call plug#end()

" Auto-install by default
autocmd VimEnter * PlugInstall

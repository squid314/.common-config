" .vimrc extension

" always iMproved
set nocompatible
" enable syntax highlighting
syntax enable
" set colors to a good set for a black background (note that this is ugly for Mac outside of tmux)
colorscheme evening
" set tabs to expand default and at 4 chars
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent

" setup for vundle (https://github.com/gmarik/Vundle.vim)
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
" statusline
"Plugin 'bling/vim-airline'
" additional syntaxes
Plugin 'puppetlabs/puppet-syntax-vim'
Plugin 'tfnico/vim-gradle'
Plugin 'fatih/vim-go'
call vundle#end()
filetype plugin indent on

" set up *.gradle files to be highlighted as groovy syntax (which they are)
au BufNewFile,BufRead *.gradle setf groovy

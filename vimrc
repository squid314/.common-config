" .vimrc extension

" always iMproved
set nocompatible
" enable syntax highlighting
syntax enable
" set colors to a good set for a black background (note that this is ugly for Mac outside of tmux)
colorscheme evening
" set tabs to expand default and at 4 chars
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent
" show first search match as i type a pattern
if has('reltime')
    set incsearch
endif

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
Plugin 'derekwyatt/vim-scala'
Plugin 'tpope/vim-fugitive'
Plugin 'restore_view.vim'
Plugin 'ktvoelker/sbt-vim'
call vundle#end()
filetype plugin indent on

" set up *.gradle files to be highlighted as groovy syntax (which they are)
au BufNewFile,BufRead *.gradle setf groovy

" if ~/.vim-tmp is present, place the backup and swap files there instead of
" next to the file being edited; if not present, do the default
set backupdir=~/.vim-tmp,.
set directory=~/.vim-tmp,.

" map 'jj','jk','kj' to <Esc> to keep hands on the home row more
imap jj <Esc>
imap jk <Esc>

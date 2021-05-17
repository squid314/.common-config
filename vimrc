" .vimrc extension

" always iMproved
set nocompatible

" pull in the defaults (i wonder how much of this file i built is not needed)
unlet! skip_defaults_vim
if filereadable(expand("$VIMRUNTIME/defaults.vim"))
    source $VIMRUNTIME/defaults.vim
endif

" enable syntax highlighting
syntax enable
" set colors to a good set for a black background (note that this is ugly for Mac outside of tmux)
colorscheme evening
" set tabs to expand default and at 4 chars
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent
" some sh syntax files add "." to iskeyword but allow you to request they not
let g:sh_noisk=1
" tell sh.vim syntax to assume script type is bash
let g:is_bash=1
" sh folding all the things
let g:sh_fold_enabled=7
" show first search match as i type a pattern
if has('reltime')
    set incsearch
endif

" ensure that statusline has file position indicator
set ruler
" highlight searches by default
set hls
" scroll only when the cursor is at the edge of the screen
set scrolloff=0

" setup for vundle (https://github.com/gmarik/Vundle.vim)
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
" additional syntaxes
"Plugin 'puppetlabs/puppet-syntax-vim'
Plugin 'tfnico/vim-gradle'
"Plugin 'fatih/vim-go'
Plugin 'leafgarland/typescript-vim'
Plugin 'pangloss/vim-javascript'
Plugin 'hashivim/vim-vagrant'
Plugin 'avakhov/vim-yaml'
Plugin 'chr4/nginx.vim'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'udalov/kotlin-vim'
Plugin 'martinda/Jenkinsfile-vim-syntax'
Plugin 'mustache/vim-mustache-handlebars'
" scala stuff
Plugin 'derekwyatt/vim-scala'
"Plugin 'ktvoelker/sbt-vim'
" git
Plugin 'tpope/vim-fugitive'

Plugin 'restore_view.vim'
call vundle#end()
filetype plugin indent on

" save/restore options
set viewoptions-=options,curdir
set viewoptions+=slash,unix
set sessionoptions-=blank,help,options,terminal
set sessionoptions+=localoptions

" set up *.gradle files to be highlighted as groovy syntax (which they are)
au BufNewFile,BufRead *.gradle setf groovy

" map 'jj','jk' to <Esc> to keep hands on the home row more
imap jj <Esc>
imap jk <Esc>

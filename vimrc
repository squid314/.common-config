" .vimrc extension

" always iMproved
set nocompatible

" pull in the defaults (i wonder how much of this file i built is not needed)
unlet! skip_defaults_vim
if filereadable(expand("$VIMRUNTIME/defaults.vim"))
    source $VIMRUNTIME/defaults.vim
endif

" add .common-config/vim in case system doesn't provide thing(s) i want
set rtp+=~/.common-config/vim

" redhat does some annoying things if autocmd is available
" so we just disable it all
if exists("#redhat")
    augroup redhat
        autocmd!
    augroup END
endif

" enable syntax highlighting
syntax enable
" set colors (previously used "evening" but the colors changed)
colorscheme default
" set tabs to expand default and at 4 chars
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent
" some sh syntax files add "." to iskeyword but allow you to request they not
let g:sh_noisk=1
" tell sh.vim syntax to assume script type is bash
let g:is_bash=1
" sh folding all the things
let g:sh_fold_enabled=7
" show first search match as i type a pattern
if has('reltime') | set incsearch | endif

" ensure that statusline has file position indicator
set ruler
" highlight searches by default, but do so quickly
set hlsearch
set redrawtime=200
" scroll only when the cursor is at the edge of the screen
set scrolloff=0

" save/restore options
set viewoptions-=options
set viewoptions-=curdir
set viewoptions+=slash
set viewoptions+=unix
set sessionoptions-=blank
set sessionoptions-=help
set sessionoptions-=options
set sessionoptions-=terminal
set sessionoptions+=localoptions

" diff options
set diffopt+=context:3

" map 'jj','jk' to <Esc> to keep hands on the home row more
imap jj <Esc>
imap jk <Esc>

" setup for vundle (https://github.com/gmarik/Vundle.vim)
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
if exists(':Plugin')
    Plugin 'gmarik/Vundle.vim'
    " additional syntaxes
    "Plugin 'puppetlabs/puppet-syntax-vim'
    Plugin 'tfnico/vim-gradle'
    "Plugin 'fatih/vim-go'
    Plugin 'leafgarland/typescript-vim'
    Plugin 'pangloss/vim-javascript'
    Plugin 'hashivim/vim-vagrant'
    Plugin 'hashivim/vim-terraform'
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
endif
call vundle#end()
filetype plugin indent on

" set up *.gradle files to be highlighted as groovy syntax (which they are)
autocmd BufNewFile,BufRead *.gradle setfiletype groovy

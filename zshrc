
PS1='%n@%m %~ %# '

alias ls=ls\ -GF
alias li=ls\ -lashi
alias sudo=sudo\ 

setopt HIST_IGNORE_SPACE

export HOMEBREW_NO_AUTO_UPDATE=true

autoload -Uz +X compinit
compinit

# case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# vim only
export EDITOR=vim VISUAL=vim
export PAGER=less

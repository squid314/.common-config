# .bashrc

# if not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# set up the config root directory since lots of files are based there
CONFIG_ROOT="`dirname ${BASH_ARGV[0]}`"
# make sure pathmunge is available
if ! declare -f pathmunge > /dev/null ; then . "$CONFIG_ROOT/pathmunge.sh" ; fi

# any completions you add in ~/.bash_completion are sourced last
if [ -f /etc/bash_completion ] ; then . /etc/bash_completion ; fi

# don't put spaced or duped lines in the history
HISTCONTROL=ignoreboth
# store a lot of history because disk space is cheap
HISTSIZE=100000

# common aliases
if [ -f "$CONFIG_ROOT/bash_aliases" ] ; then source "$CONFIG_ROOT/bash_aliases" ; fi

# git stuff
if [ -f ~/.git-completion.bash ] ; then . ~/.git-completion.bash ; fi
if [ -f ~/.git-prompt.sh ] ; then . ~/.git-prompt.sh ; fi
export GIT_PS1_SHOWDIRTYSTATE=true GIT_PS1_SHOWSTASHSTATE=true GIT_PS1_SHOWUPSTREAM=auto
# spring boot
[ -f ~/.gvm/springboot/current/shell-completion/bash/spring ] && source ~/.gvm/springboot/current/shell-completion/bash/spring

# prefered programs
export PAGER=less VISUAL=vim EDITOR=vim
# shell should glob on C locale, but let others use system locale. this means that [a-z]* doesn't glob files like Makefile, README, etc.
LC_COLLATE=C

# pull in .sh files from bashrc.d (allowing extra support files to be present in bashrc.d if desired)
if [ -d "$CONFIG_ROOT/bashrc.d" ] ; then
    for scr in "$CONFIG_ROOT"/bashrc.d/*.sh ; do
        if [ -r "$scr" ] ; then source "$scr" ; fi
    done
    unset scr
fi

# immediately update the .bash_history file
PROMPT_COMMAND="${PROMPT_COMMAND:+${PROMPT_COMMAND} ; }history -a"
# if using ssh-agent helper, add it to the prompt command
if declare -f agent > /dev/null ; then
    PROMPT_COMMAND="${PROMPT_COMMAND} ; agent verify"
fi
# if using git stuff, add eval for git info
if declare -f __git_ps1 > /dev/null ; then
    PROMPT_COMMAND="${PROMPT_COMMAND}"' ; MY_GIT_PS1="$(__git_ps1)"'
fi
# better prompt (window title gets git info, nice colors, last cmd status indicator)
PS1='\[\e]0;\w$MY_GIT_PS1\007\e[0;1;34m\]\u \[\e[32m\]\w${_MY_VIRTUAL_ENV:+ }\[\e[0;35m\]$_MY_VIRTUAL_ENV\[\e[1;32m\]$MY_GIT_PS1 `[[ $? -eq 0 ]]&&echo ":)"||echo "\[\e[31m\]:("`\[\e[0;31m\] \$\[\e[0m\] '

# load various version/environment managers
if [[ -r "$HOME/.rvm/scripts/rvm"     ]] ; then source "$HOME/.rvm/scripts/rvm"     ; fi
if [[ -r "$HOME/.nvm/nvm.sh"          ]] ; then source "$HOME/.nvm/nvm.sh"          ; fi
if [[ -r "$HOME/.gvm/bin/gvm-init.sh" ]] ; then source "$HOME/.gvm/bin/gvm-init.sh" ; fi

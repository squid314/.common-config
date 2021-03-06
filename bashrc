# .bashrc

# if not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# always pull system config
if [[ -r /etc/bashrc ]] ; then source /etc/bashrc ;
elif [[ -r /etc/bash.bashrc ]] ; then source /etc/bash.bashrc ;
fi

# set up the config root directory since lots of files are based there
CONFIG_ROOT="$(cd $(dirname ${BASH_ARGV[0]}) ; pwd)"

# make sure important functions are available
for s in "$CONFIG_ROOT"/bashrc.func.d/*.sh ; do source "$s" ; done ; unset s

__set_up_completions() {
    local s f

    # try to find all the possible locations of completion enhancements
    if [[ -f /etc/bash_completion ]] ; then source /etc/bash_completion
    elif [[ -d /etc/bash_completion.d ]] ; then for s in /etc/bash_completion.d/* ; do source "$s" ; done
    fi
    if [[ -f /usr/share/bash-completion/bash_completion ]] ; then source /usr/share/bash-completion/bash_completion ; fi
    if [[ -f /usr/local/share/bash-completion/bash_completion ]] ; then source /usr/local/share/bash-completion/bash_completion ; fi
    for f in /usr/share/bash{-,_}completion{,.d}{,/completions} ; do
        if [[ -d "$f" ]] ; then
            for s in "$f"/* ; do
                if [[ -f "$s" ]] ; then
                    source "$s"
                fi
            done
        fi
    done
}
# completions seem oddly broken on various systems, so by default ignore all output
__set_up_completions &>/dev/null

# prefer umask with no group write (some systems default to allow it)
umask 0022

# don't put spaced or duped lines in the history
HISTCONTROL=ignoreboth
# store a lot of history because disk space is cheap
HISTSIZE=10000000
# always history append
shopt -s histappend

# update the window size frequently since i use tmux and have weird windows
shopt -s checkwinsize
# disable that silly legacy option to enable/disable flow control
if type stty &>/dev/null ; then stty -ixon -ixoff ; fi

# spring boot
if [[ -f ~/.gvm/springboot/current/shell-completion/bash/spring ]] ; then source ~/.gvm/springboot/current/shell-completion/bash/spring ; fi
# gradle completion (https://github.com/gradle/gradle-completion)
if [[ -f ~/.gradle-completion.bash ]] ; then . ~/.gradle-completion.bash ; complete -F _gradle gw ; fi

# prefered programs
export PAGER=less VISUAL=vim EDITOR=vim
# shell should glob on C locale, but let others use system locale. this means that [a-z]* doesn't glob files like Makefile, README, etc.
LC_COLLATE=C

# pull in .sh files from bashrc.d (allowing extra support files to be present in bashrc.d if desired)
if [[ -d "$CONFIG_ROOT/bashrc.d" ]] ; then
    for s in "$CONFIG_ROOT"/bashrc.d/*.sh ; do
        # check if the script has been disabled in the git config before sourcing it
        if [[ -r "$s" ]] &&
            ! bconf "bashrc.d.$(basename $s)=disabled"
        then
            source "$s"
        fi
    done
    unset s
fi

# immediately update the .bash_history file
prompt add 'history -a'
# if using git stuff, add eval for git info
if declare -f __git_ps1 > /dev/null ; then
    prompt add '__git_ps1_value="$(__git_ps1)"'
fi
prompt add '__ps1_jobs=($(jobs -p))'

# TODO `agent verify` creates a background job, somehow, that is alive through a `jobs -p` test and then finishes before the prompt is displayed, so we have to put the __ps1_jobs setup before that
# if using ssh-agent helper, add it to the prompt command
if declare -f agent >/dev/null ; then
    prompt add 'agent verify'
fi
# better prompt (window title gets git info, nice colors, last cmd status indicator)
prompt add 'ps1 run $__exit'

# load various version/environment managers
if [[ -r "$HOME/.rvm/scripts/rvm"     ]] ; then source "$HOME/.rvm/scripts/rvm"     ; fi
if [[ -r "$HOME/.nvm/nvm.sh"          ]] ; then source "$HOME/.nvm/nvm.sh"          ; fi
if [[ -r "$HOME/.nvm/bash_completion" ]] ; then source "$HOME/.nvm/bash_completion" ; fi

# common aliases
if [[ -f "$CONFIG_ROOT/bash_aliases" ]] ; then source "$CONFIG_ROOT/bash_aliases" ; fi

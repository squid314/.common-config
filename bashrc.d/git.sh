# git.sh

if ! type git &>/dev/null ; then return ; fi

# system completions should be loaded by now, so git completion and prompt should be loaded. however, i expect that i will generally keep my repo more up to date than the system i'm on, so i'll load these regardless.
if [[ -f "$CONFIG_ROOT"/git/completion.bash ]] ; then . "$CONFIG_ROOT"/git/completion.bash ; fi
if [[ -f "$CONFIG_ROOT"/git/prompt.sh ]] ; then . "$CONFIG_ROOT"/git/prompt.sh ; fi

# configure prompt as desired
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM="auto git"

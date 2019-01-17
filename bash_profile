# .bash_profile extension

# set up the config root directory since lots of files are based there
CONFIG_ROOT="`dirname ${BASH_ARGV[0]}`"

source "$CONFIG_ROOT/bashrc.func.d/pathmunge.sh"
# any PATH component which is relative to the current directory is a security risk, so remove that in case some idiot added it to the system environment
PATH="$(echo $PATH | tr : \\n | egrep -v "^\." | tr \\n :)"
pathmunge /opt/X11/bin
pathmunge /sbin
pathmunge /usr/sbin
pathmunge /bin
pathmunge /usr/bin
#pathmunge /opt/local/sbin
#pathmunge /opt/local/bin
pathmunge -m /usr/local/sbin
pathmunge -m /usr/local/bin

# add user's bin to the path if it exists
if [[ -d "${HOME}/bin" ]] ; then pathmunge -m "${HOME}/bin" ; fi

# source the users bashrc if it exists
if [[ -r "${HOME}/.bashrc" ]] ; then source "${HOME}/.bashrc" ; fi

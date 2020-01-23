# .bash_profile extension

# set up the config root directory since lots of files are based there
CONFIG_ROOT="$(cd $(dirname ${BASH_ARGV[0]}) ; pwd)"

source "$CONFIG_ROOT/bashrc.func.d/path.sh"
# any PATH component which is relative to the current directory is a security risk, so remove that in case some idiot added it to the system environment
PATH="$(echo $PATH | tr : \\n | egrep -v "^\." | tr \\n :)"
path add /opt/X11/bin
path add /sbin /usr/sbin
path add /bin  /usr/bin
#path add /opt/local/sbin
#path add /opt/local/bin
path move /usr/local/sbin
path move /usr/local/bin

# add user's bin to the path if it exists
if [[ -d "${HOME}/bin" ]] ; then path move "${HOME}/bin" ; fi

# source the users bashrc if it exists
if [[ -r "${HOME}/.bashrc" ]] ; then source "${HOME}/.bashrc" ; fi

# vi: set ft=sh :

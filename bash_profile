# .bash_profile extension

# set up the config root directory since lots of files are based there
CONFIG_ROOT="`dirname ${BASH_ARGV[0]}`"

source "$CONFIG_ROOT/pathmunge.sh"
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

# set go path for building and running go applications
export GOPATH="${HOME}/.go"

# source the users bashrc if it exists
if [[ -r "${HOME}/.bashrc" ]] ; then source "${HOME}/.bashrc" ; fi

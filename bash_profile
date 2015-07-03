# .bash_profile extension

pathmunge() {
    # allow a value to be moved. done simply by removing the value from the path (if it exists) and then letting it be added normally.
    if [[ "x$1" = "x-m" ]] && echo "$PATH" | egrep "(^|:)$2($|:)" >&/dev/null ; then
        PATH="$(echo $PATH | sed -E 's;(^|:)'"$2"'($|:);\
;g' | sed '/^$/d' | tr \\n :)"
        shift
    fi

    if ! echo $PATH | egrep "(^|:)$1($|:)" >&/dev/null ; then
        if [[ "$2" = after ]] ; then
            PATH="$PATH:$1"
        else
            PATH="$1:$PATH"
        fi
    fi

    # clean up the path of extraneous blank entries
    PATH="$(echo $PATH | sed -E 's/::+/:/g;s/^:|:$//g')"
}
pathmunge /opt/X11/bin
pathmunge /sbin
pathmunge /usr/sbin
pathmunge /bin
pathmunge /usr/bin
pathmunge /opt/local/sbin
pathmunge /opt/local/bin
pathmunge -m /usr/local/bin

# add user's bin to the path if it exists
if [[ -d "${HOME}/bin" ]] ; then pathmunge "$HOME/bin" ; fi

# set go path for building and running go applications
export GOPATH="${HOME}/.go"

# source the users bashrc if it exists
if [[ -r "$HOME/.bashrc" ]] ; then source "$HOME/.bashrc" ; fi

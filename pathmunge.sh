# pathmunge.sh

# function to add an element to the user's path but prevent it from appearing multiple times
pathmunge() {
    # allow a value to be moved. done simply by removing the value from the path (if it exists) and then letting it be added normally.
    if [[ "x$1" = "x-m" || "x$1" = "x-d" ]] ; then
        if echo "$PATH" | egrep "(^|:)$2($|:)" &>/dev/null ; then
            PATH="$(echo $PATH | tr : \\n | egrep -v "^$2$" | tr \\n :)"
        fi
        if [[ "x$1" = "x-d" ]] ; then return 0 ; fi
        shift
    fi

    if ! echo $PATH | egrep "(^|:)$1($|:)" &>/dev/null ; then
        if [[ "$2" = after ]] ; then
            PATH="$PATH:$1"
        else
            PATH="$1:$PATH"
        fi
    fi

    # clean up the path of extraneous blank entries
    PATH="$(echo $PATH | sed 's/:::*/:/g;s/^://;s/:$//')"
}

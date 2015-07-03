# pathmunge.sh

# function to add an element to the user's path but prevent it from appearing multiple times
pathmunge() {
    # allow a value to be moved. done simply by removing the value from the path (if it exists) and then letting it be added normally.
    if [ "x$1" = "x-m" ] && echo "$PATH" | egrep "(^|:)$2($|:)" >&/dev/null ; then
        PATH="$(echo $PATH | sed -E 's;(^|:)'"$2"'($|:);\
;g' | sed '/^$/d' | tr \\n :)"
        shift
    fi

    if ! echo $PATH | egrep "(^|:)$1($|:)" >&/dev/null ; then
        if [ "$2" = after ] ; then
            PATH="$PATH:$1"
        else
            PATH="$1:$PATH"
        fi
    fi

    # clean up the path of extraneous blank entries
    PATH="$(echo $PATH | sed -E 's/::+/:/g;s/^:|:$//g')"
}

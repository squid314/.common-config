#!/bin/bash

# script to search for file(s) inside of jar(s)

# capture the search string
SEARCH="$1"
shift

# loop over the remaining arguments
while [ "$#" -gt 0 ] ; do
    # if the argument contains any ':', separate the argument on those and pass them back to this script.
    # this allows the direct inclusion of classpath-like arguments.
    if echo "$1" | grep -q : ; then
        # replace the ':' with null and pipe to xargs
        echo -n "$1" | tr : \\00 | xargs --null "$0" "$SEARCH" 
    else
        # normal case, single item; do the search

        # if it's a directory, then we search it for files
        if [ -d "$1" ] ; then
            find "$1" -name "*$SEARCH*" -ls
        # if it's a regular file (hopefully a jar), then search its contents
        elif [ -f "$1" ] ; then
            RESULT="$(unzip -l "$1" 2>/dev/null | grep --color=always "$SEARCH" 2>/dev/null)"
            # grep success: found a result
            if [ $? = 0 ] ; then
                echo -e "In \e[1;31m$(ls -lashi "$1")\e[0m\n$RESULT"
            fi
        # otherwise, we can't handle it
        else
            echo unexpected file \""$1"\" >&2
        fi
    fi
    shift
done

:

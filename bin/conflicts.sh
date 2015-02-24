#!/bin/bash

# old version which trimmed the top and bottom lines; new version looks for "deleted by" lines to limit to those which have 2 copies
#for conflict in $(git st |
#    sed -n '/Unmerged paths/,/Untracked\|Changes not staged/p' |
#    head -n -2 |
#    tail -n +4 |
#    awk -F: '{print $2}')

# get the list of all files which are currently unmerged
for conflict in $(git st |
    sed -n '/Unmerged paths/,/Untracked\|Changes not staged/p' |
    grep 'deleted by' |
    awk -F: '{print $2}')
do
    # edit both versions of the file
    vimdiff $(find . -type d \( -name target -o -name .git \) -prune -false -o -iname $(basename $conflict))

    # ask if the file is ready to be resolved
    read -p "Resolve $(basename $conflict) (Y/n)? " resolve || exit 1
    if [ -z "$resolve" -o "$resolve" = 'Y' -o "$resolve" = 'y' ] ; then
        # resolve by removing the "old" version and adding the "new" version
        git rm $conflict && \
            git add $(find . -type d \( -name target -o -name .git \) -prune -false -o -iname $(basename $conflict))
    else
        echo
        read -p 'Break (y/N)? ' dobreak || exit 1
        if [ "$dobreak" = 'Y' -o "$dobreak" = 'y' ] ; then
            break
        fi
    fi
done

# darwin.sh
# special stuff that I want applied for darwin systems (macs)
# this might apply to bsd systems as well, but I don't use any yet, so i'll not call them out

if [[ "`uname`" == Darwin ]] ; then
    # override ls because mac (or bsd) doesn't have --color
    alias ls='ls -GF'
    # alter mac terminal colors to make directories use bright blue instead of dark blue
    export LSCOLORS=Exfxcxdxbxegedabagacad

    # pull in homebrew installed completion files
    for s in /usr/local/etc/bash_completion.d/* ; do
        source "$s"
    done
    unset s
    if [[ -f /usr/local/share/bash-completion/bash_completion ]] ; then source /usr/local/share/bash-completion/bash_completion ; fi
    if [[ -d /usr/local/share/bash-completion/completions ]] ; then
        for s in /usr/local/share/bash-completion/completions/* ; do
            source "$s"
        done
        unset s
    fi
fi

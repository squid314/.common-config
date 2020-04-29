# darwin.sh
# special stuff that I want applied for darwin systems (macs)
# this might apply to bsd systems as well, but I don't use any yet, so i'll not call them out

if [[ "`uname`" == Darwin ]] ; then
    # override ls because mac (or bsd) doesn't have --color
    alias ls='ls -GF'
    # alter mac terminal colors to make directories use bright blue instead of dark blue
    export LSCOLORS=Exfxcxdxbxegedabagacad
fi

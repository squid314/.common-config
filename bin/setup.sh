#!/bin/bash

set -e

setup() {
    DISABLE_AGENT=no
    USERONLY=no
    while [[ $# -gt 0 ]] ; do
        case "$1" in
            # direct actions
            no-agent) DISABLE_AGENT=yes ;;
            user-only) USERONLY=yes ;;
            # environments
            docker) DISABLE_AGENT=yes ;;
            new-comp) USERONLY=yes ;;
        esac
        shift
    done


    if [[ ! -d ~/.common-config ]] ; then
        if type git &>/dev/null ; then
            git clone --depth 1 https://github.com/squid314/.common-config.git
            git --git-dir=.common-config/.git/ config --add remote.origin.prune true
        else
            curl -sL https://github.com/squid314/.common-config/archive/master.tar.gz | tar zx
            mv .common-config{-master,}
        fi
        cp -f .common-config/.{bash{_profile,rc},git{config,ignore},inputrc,tmux.conf,vimrc} .
    else
        (
            cd ~/.common-config/
            git pff || :
        )
    fi

    case "$(echo .ssh/id_*)" in
        .ssh/id_\*)
            mkdir -p .ssh
            chmod 700 .ssh
            ssh-keygen -q -t ed25519 -N '' -f .ssh/id_ed25519
            echo "New public key:"
            cat .ssh/id_ed25519.pub
            ;;
        *) ;; # already have key(s)
    esac

    if [[ ! -d ~/.vim/bundle/Vundle.vim ]] ; then
        # initially set up vundle
        if type git &>/dev/null ; then
            git clone --depth 1 https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
        else
            curl -sL https://github.com/gmarik/Vundle.vim/archive/master.tar.gz | tar zx
            mkdir -p .vim/bundle
            mv Vundle.vim-master .vim/bundle/Vundle.vim
        fi
    fi

    if [[ $DISABLE_AGENT == yes ]] ; then
        echo 'bashrc.d.ssh-agent-share.sh=disabled' >>~/.bashrc.conf
    fi

    if [[ $USERONLY == yes ]] ; then
        echo 'bashrc.ps1.userhost=useronly' >>~/.bashrc.conf
    fi
}

# protect against executing a partially downloaded script
setup "$@"

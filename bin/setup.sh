#!/bin/bash

set -e

setup() {
    # defaults to be overridden by args
    SSH_AGENT=yes
    USER_ONLY=no
    SSH_KEY=yes
    while [[ $# -gt 0 ]] ; do
        case "$1" in
            # direct actions
            no-agent) SSH_AGENT=no ;;
            no-key) SSH_KEY=no ;;
            user-only) USER_ONLY=yes ;;
            # environments
            docker) SSH_AGENT=no ;;
            new-comp) USER_ONLY=yes ;;
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

    if [[ $SSH_AGENT == no ]] ; then
        echo 'bashrc.d.ssh-agent-share.sh=disabled' >>~/.bashrc.conf
    fi

    if [[ $SSH_KEY == no ]] ; then
        echo 'bashrc.d.ssh-keygen.sh=disabled' >>~/.bashrc.conf
    fi

    if [[ $USER_ONLY == yes ]] ; then
        echo 'bashrc.ps1.userhost=useronly' >>~/.bashrc.conf
    fi
}

# protect against executing a partially downloaded script
setup "$@"

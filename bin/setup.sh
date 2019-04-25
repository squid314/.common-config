#!/bin/bash

set -e

setup() {
    # defaults to be overridden by args
    SSH_AGENT=yes
    SSH_KEY=yes
    USER_ONLY=no
    REWRITE_GIT_TO_SSH=no
    echo Args: "$@"
    while [[ $# -gt 0 ]] ; do
        case "$1" in
            # direct actions
            no-agent) SSH_AGENT=no ;;
            no-key) SSH_KEY=no ;;
            user-only) USER_ONLY=yes ;;
            git-ssh) REWRITE_GIT_TO_SSH=yes ;; # don't set no-key if using this option
            # environments
            docker) SSH_AGENT=no ;;
            new-comp) USER_ONLY=yes ;;
            vagrant) SSH_AGENT=no ; SSH_KEY=no ;;
        esac
        shift
    done
    printf 'Settings for %s:' $HOSTNAME
    printf ' % 12s=%-4s' \
        agent $SSH_AGENT \
        key $SSH_KEY \
        user-only $USER_ONLY \
        git-ssh $REWRITE_GIT_TO_SSH \
        has-git $(type git &>/dev/null && echo yes || echo no)
    printf '\n'

    cd ~

    if [[ ! -d ~/.common-config ]] ; then
        if type git &>/dev/null ; then
            git clone --config remote.origin.prune=true https://github.com/squid314/.common-config.git

            if [[ $REWRITE_GIT_TO_SSH == yes ]] ; then
                git --git-dir=.common-config/.git/ remote set-url origin git@github.com:squid314/.common-config.git
            fi
        else
            curl -sL https://github.com/squid314/.common-config/archive/master.tar.gz | tar zx
            mv .common-config{-master,}
        fi
        cp -f .common-config/.{bash{_profile,rc},git{config,ignore},inputrc,tmux.conf,vimrc} .
    else
        if type git &>/dev/null ; then
            (
                cd ~/.common-config/
                if [[ ! -d .git ]] ; then
                    git clone https://github.com/squid314/.common-config.git
                    mv .common-config/.git .git
                    git add .
                    git reset --hard
                fi
                if [[ $REWRITE_GIT_TO_SSH == yes ]] ; then
                    git remote set-url origin git@github.com:squid314/.common-config.git
                fi
                git pff || :
            )
        else
            curl -sL https://github.com/squid314/.common-config/archive/master.tar.gz | tar zx
            rm -rf .common-config
            mv .common-config{-master,}
        fi
    fi

    if [[ ! -d ~/.vim/bundle/Vundle.vim ]] ; then
        # initially set up vundle
        if type git &>/dev/null ; then
            git clone --depth 1 https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

            if [[ $REWRITE_GIT_TO_SSH == yes ]] ; then
                git --git-dir=~/.vim/bundle/Vundle.vim/.git/ remote set-url origin git@github.com:gmarik/Vundle.vim.git
                sed -i '/"\{15}BEGIN SCRIPTED VALUES"/,/"\{15}END SCRIPED VALUES"/{
                /g:vundle_default_git_proto/d
                $a\
let g:vundle_default_git_proto=git
            }' ~/.vimrc
            fi
        else
            curl -sL https://github.com/gmarik/Vundle.vim/archive/master.tar.gz | tar zx
            mkdir -p .vim/bundle
            mv Vundle.vim-master .vim/bundle/Vundle.vim
        fi
    fi

    touch .bashrc.conf
    sed -i '/^bashrc\.d\.ssh-agent-share\.sh=/d' .bashrc.conf
    if [[ $SSH_AGENT == no ]] ; then
        echo 'bashrc.d.ssh-agent-share.sh=disabled' >>.bashrc.conf
    fi

    touch .bashrc.conf
    sed -i '/^bashrc\.d\.ssh-keygen\.sh=/d' .bashrc.conf
    if [[ $SSH_KEY == no ]] ; then
        echo 'bashrc.d.ssh-keygen.sh=disabled' >>.bashrc.conf
    fi

    touch ~/.bashrc.conf
    sed -i '/^bashrc\.ps1\.userhost=/d' .bashrc.conf
    if [[ $USER_ONLY == yes ]] ; then
        echo 'bashrc.ps1.userhost=useronly' >>.bashrc.conf
    fi
    echo Updated .bashrc.conf:
    cat .bashrc.conf
}

# protect against executing a partially downloaded script
setup "$@"

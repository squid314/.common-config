# bashrc.d/vagrant.sh


if ! type vagrant &>/dev/null ; then return ; fi

v() {
    if [[ $# = 0 ]] ; then
        vagrant global-status --prune
    elif [[ $1 = ssh ]] ; then
        shift
        # vagrant finds in pwd ancestry, but not inside vagrant/ dirs
        if [[ -z "$(upfind Vagrantfile 2>/dev/null)" ]] ; then
            # try to check obvious places nearby
            if [[ -f vagrant/Vagrantfile ]] ; then
                cd vagrant
            elif [[ -f */vagrant/Vagrantfile ]] ; then
                cd $(dirname */vagrant/Vagrantfile)
            fi
        fi
        vagrant ssh "$@"
    elif [[ $1 = st ]] ; then
        shift
        vagrant status "$@"
    elif [[ $1 = setup ]] ; then
        local vm=$2
        shift 2
        (
            set -e
            vagrant destroy -f $vm
            vagrant up $vm
            if [[ -f install/dnf-cache ]] ; then
                vagrant ssh $vm -- -t -- sudo /vagrant/install/dnf-cache load \; sudo yum install -y git vim
            else
                vagrant ssh $vm -- -t -- sudo yum install -y git vim
            fi
            vagrant ssh $vm -- -t -- bash -s - vagrant <~/.common-config/bin/setup.sh
            exec vagrant ssh $vm -- -t -- "$@"
        )
    else
        vagrant "$@"
    fi
}
recomplete v vagrant

# vim: ts=4 sts=4 sw=4 et ft=sh :

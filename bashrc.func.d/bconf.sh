# bconf.sh
# function to enable easy config testing

bconf() {
    test -e $CONFIG_ROOT/../.bashrc.conf &&
        grep -qE "^$1$" $CONFIG_ROOT/../.bashrc.conf
} &>/dev/null

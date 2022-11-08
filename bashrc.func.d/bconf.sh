# bconf.sh
# function to enable easy config testing

bconf() {
    grep -qE "^$1$" "$HOME/.bashrc.conf"
} &>/dev/null

bget() {
    if [[ $# = 0 ]] ; then
        cat "$HOME/.bashrc.conf"
    else
        sed -n "s/^$1=\(.*\)$/\1/p" "$HOME/.bashrc.conf"
    fi
}
bset() {
    local conf="$(< "$HOME/.bashrc.conf")"
    sed -e "/^$1=.*$/d" <<<"$conf" |
    if [[ $# -eq 2 ]] ; then
        sed -e "$""a\\
$1=$2"
    else
        cat
    fi >"$HOME/.bashrc.conf"
}

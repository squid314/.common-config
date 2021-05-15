# bconf.sh
# function to enable easy config testing

bconf() {
    grep -qE "^$1$" "$HOME/.bashrc.conf"
} &>/dev/null

bget() {
    sed -n "s/^$1=\(.*\)$/\1/p" "$HOME/.bashrc.conf"
}
bset() {
    sed -i '' \
        -e "/^$1=.*$/d" \
        "$HOME/.bashrc.conf"
    sed -i '' \
        -e "$""a\\
$1=$2" \
        "$HOME/.bashrc.conf"
}

# bconf.sh
# function to enable easy config testing

bconf() {
    grep -qE "^$1$" "$HOME/.bashrc.conf"
} &>/dev/null

bget() {
    sed -n "s/^$1=\(.*\)$/\1/p" "$HOME/.bashrc.conf"
}
bset() {
    local conf="$(< "$HOME/.bashrc.conf")"
    sed -e "/^$1=.*$/d" \
        -e "$""a\\
$1=$2" \
        <<<"$conf" >"$HOME/.bashrc.conf"
}

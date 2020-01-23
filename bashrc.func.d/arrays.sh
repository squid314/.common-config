# arrays.sh
# provides utils for arrays

__array_has() {
    local -n ary="$1" ; shift
    local search="$1" tmp
    for tmp in "${ary[@]}" ; do
        if [[ $tmp = $search ]] ; then
            return 0
        fi
    done
    return 1
}

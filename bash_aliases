# .bash_aliases

# add grep colors option
alias grep='grep --color=auto'

# better ls(1)
alias ls='ls --color=auto'
alias li='ls -lashi'

# let alias substitution occur after commands suppliment others
alias sudo='sudo '
alias xargs='xargs '
alias caffeinate='caffeinate '

# prefer vim over vi in all the things
if type vim &>/dev/null ; then
    alias  vi='vim'     \
          rvi='vim -Z'  \
         view='vim -R'  \
        rview='vim -ZR' \
           ex='vim -e'
fi

# quick file find in pwd; prune all directories named in find-prunes
alias ff='find . -type d \( $(sed "/^#/d;/^ *\$/d;s/.*/-name & -o/" "${CONFIG_ROOT}/find-prunes") -false \) -prune -false -o -iname'
alias fr='find . -type d \( $(sed "/^#/d;/^ *\$/d;s/.*/-name & -o/" "${CONFIG_ROOT}/find-prunes") -false \) -prune -false -o -iregex'

# function to find the closest ancestor directory (or current directory) which has the named entity
upfind() {
    d="`pwd`"
    while [ "$d" != "/" ] && [ ! -r "$d/$1" ] ; do
        d="`dirname $d`"
    done
    if [ -r "$d/$1" ] ; then
        echo "$d/$1"
    else
        echo "failed to find $1 in pwd ancestry">&2
        return 1
    fi
}
# maven build stuff
alias m='mvn -f "`upfind pom.xml`"'
alias mp='m package'
alias mct='m clean test'
alias mcp='m clean package'
alias mci='m clean install'
alias mcd='m clean deploy'
alias mg='mvn -f `git rev-parse --show-cdup`pom.xml'
# gradle
alias gw='./gradlew'
# sigterm a process run by `./gradlew bootRun`
alias bootdie="ps -ef | awk '/java/ && /spring-boot-starter/ && !/awk/ {print \$2}' | xargs kill"
# i don't like global installs that don't need to be, so this relieves me of some of that for grunt
alias gr='node node_modules/.bin/grunt'

if type kubectl &>/dev/null ; then
    alias k='kubectl'
fi

alias pyjs='python -m json.tool'
alias tmd='tmux new-session -As default'
alias pgrep='ps -ef | grep -i'

if ! type shred &>/dev/null && type srm &>/dev/null ; then
    alias shred=srm
fi

# function for math stats
st() {
    if [[ $1 = --no-name ]] ; then
        awk '{
                 for(i=1;i<=NF;i++) {
                     sum[i] += $i;
                     sumsq[i] += ($i)^2
                 }
             }
             END {
                 printf "count: %d \n", NR
                 for (i=1;i<=NF;i++) {
                     printf "%f %f \n",
                         sum[i]/NR,
                         sqrt((sumsq[i]-sum[i]^2/NR)/NR)
                 }
             }'
    else
        awk '{
                 for(i=2;i<=NF;i++) {
                     if(i==2) count[$1] += 1
                     sum[$1 i] += $i
                     sumsq[$1 i] += ($i)^2
                 }
             }
             END {
                 for (n in count) {
                     printf "%s count: %d\n", n, count[n]
                 }
                 for (i=2;i<=NF;i++) {
                     for (n in count) {
                         printf "%s: %f %f\n",
                             n "$" i,
                             sum[n i]/count[n],
                             sqrt((sumsq[n i]-sum[n i]^2/count[n])/count[n])
                     }
                 }
             }'
    fi
}

# vim: ts=4 sts=4 sw=4 et ft=sh :

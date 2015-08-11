# .bash_aliases

# add grep colors option
alias grep="grep --color=auto"

# better ls(1)
alias ls='ls --color=auto'
alias li='ls -lashi'

# rebuild and install git (from the latest release tag)
alias makegit='bash -c "cd ~/.bin/git && git fetch --verbose && git checkout \$(git log --simplify-by-decoration --decorate --oneline origin/master | sed -n \"/tag: v[0-9.]*[),]/{s/.*tag: \\(v[^),]*\\).*/\\1/;p;q}\") && make clean && make PROFILE=BUILD NO_EXPAT=YesPlease NO_TCLTK=YesPlease install || echo -e \\\\e[1\;31mum...problems?"'

# navigate around a maven project
alias cdjav='cd `git rev-parse --show-cdup`src/main/java'
alias    cj='cd `git rev-parse --show-cdup`src/main/java'
alias cdapp='cd `git rev-parse --show-cdup`src/main/webapp'
alias    ca='cd `git rev-parse --show-cdup`src/main/webapp'
# go to the top of a git repo
alias   gup='cd "`git rev-parse --show-cdup`"'

# quick file find in pwd
alias ff='find . -type d \( -name target -o -name .git \) -prune -false -o -iname'
alias fr='find . -type d \( -name target -o -name .git \) -prune -false -o -iregex'

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
alias mcp='m clean package'
alias mci='m clean install'
alias mcd='m clean deploy'
alias mg='mvn -f `git rev-parse --show-cdup`pom.xml'

# vagrant stuff
alias va='vagrant'
alias vst='va global-status'
alias vup='va up'
alias vhalt='va halt'
alias vrm='va destroy'
alias vssh='va ssh'

alias pyjson="python -m json.tool"
alias tmd="tmux new-session -As default"

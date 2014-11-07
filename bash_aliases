# .bash_aliases

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

# maven build stuff
alias m='mvn -f `git rev-parse --show-cdup`pom.xml'
alias mcp='m clean package'

alias pyjson="python -m json.tool"
alias tmd="tmux new-session -As default"

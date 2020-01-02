# git.sh

if ! type git &>/dev/null ; then return ; fi

# system completions should be loaded by now, so git completion and prompt should be loaded. however, i expect that i will generally keep my repo more up to date than the system i'm on, so i'll load these regardless.
if [[ -f "$CONFIG_ROOT"/git/completion.bash ]] ; then . "$CONFIG_ROOT"/git/completion.bash ; fi
if [[ -f "$CONFIG_ROOT"/git/prompt.sh ]] ; then . "$CONFIG_ROOT"/git/prompt.sh ; fi

# configure prompt as desired
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM="auto git"


g() {
    if [[ $# = 0 ]] ; then
        git status
    elif [[ $1 = cd && $# = 2 ]] ; then
        case $2 in
            j|java)  cd "$(git rev-parse --show-cdup)src/main/java"   ;;
            s|scala) cd "$(git rev-parse --show-cdup)src/main/scala"  ;;
            a|app)   cd "$(git rev-parse --show-cdup)src/main/webapp" ;;
            up)      cd "$(git rev-parse --show-cdup)" ;;
            *)       echo "g: error: huh?" >&2 ;;
        esac
    elif [[ $1 = make ]] ; then
        # rebuild and install git (from the latest release tag)
        (
            set -e
            cd ~/.bin/git
            git fetch --verbose --depth=10
            TAG="$(git log --simplify-by-decoration --decorate --oneline origin/master | sed -n '/tag: v[0-9.]*[),]/{s/.*tag: \(v[^),]*\).*/\1/;p;q}')"
            git checkout $TAG
            make clean
            make PROFILE=BUILD NO_EXPAT=YesPlease NO_TCLTK=YesPlease install
        )
    else
        git "$@"
    fi
}
if declare -f __git_complete &>/dev/null ; then
    __git_complete g __git_main
fi

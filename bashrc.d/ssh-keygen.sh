# ssh-key.sh

case "$(echo .ssh/id_*)" in
    .ssh/id_\*)
        mkdir -p .ssh
        chmod 700 .ssh
        ssh-keygen -q -t ed25519 -N '' -f .ssh/id_ed25519
        ;;
    *) ;; # already have key(s)
esac

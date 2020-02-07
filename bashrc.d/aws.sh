# aws.sh
# aws cli stuff

# add completion support
if ! type aws &>/dev/null ; then return ; fi

complete -C aws_completer aws

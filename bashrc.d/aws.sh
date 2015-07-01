# aws.sh
# aws cli stuff

# add completion support
if which aws >&/dev/null ; then
    complete -C aws_completer aws
fi

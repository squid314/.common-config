# go.sh

# don't do anything if go is not present
if ! type go &>/dev/null ; then return ; fi

# set go path for building and running go applications
export GOPATH="${HOME}/.go"

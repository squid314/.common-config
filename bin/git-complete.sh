#!/bin/sh

CONFIG_ROOT="`dirname \`dirname $0\``"

curl -sL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o "$CONFIG_ROOT"/git/completion.bash
curl -sL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o "$CONFIG_ROOT"/git/prompt.sh

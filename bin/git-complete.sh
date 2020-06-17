#!/bin/sh -ex

CONFIG_ROOT="`dirname \`dirname $0\``"

curl -sL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o "$CONFIG_ROOT"/git/completion.bash
curl -sL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o "$CONFIG_ROOT"/git/prompt.sh

git -C "$CONFIG_ROOT" status
git -C "$CONFIG_ROOT" commit -m 'pull latest git completion and prompt' --patch git/prompt.sh git/completion.bash

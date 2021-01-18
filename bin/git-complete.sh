#!/bin/sh -ex

CONFIG_ROOT="`cd \`dirname $0\`/.. ; pwd`"

curl -sL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o "$CONFIG_ROOT"/git/completion.bash
curl -sL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh       -o "$CONFIG_ROOT"/git/prompt.sh

git -C "$CONFIG_ROOT" status
git -C "$CONFIG_ROOT" commit -m 'git: pull latest completion and prompt' git/prompt.sh git/completion.bash

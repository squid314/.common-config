# Scripty Stuff
Just a collection of scripts and script-like things (configs, etc.) of which I want to keep track.

Default config files exist here (.vimrc, .tmux.conf, etc.) which source in file(s) from this repository to extend functionality. This provides a nice, simple quick start platform to get your environment configured. You can start using this config by running the setup script:

    curl -o- https://raw.githubusercontent.com/squid314/.common-config/master/bin/setup.sh | bash -s -
    ## ~or~ ##
    curl -Lo- https://a.blmq.us/setup-sh | bash -s -

If you don't want a `bashrc.d` script to run, just add a config setting to the common-config's git config. For example,

    echo 'bashrc.d.ssh-agent-share.sh=disabled' >>~/.bashrc.conf

If you want the ps1 prompt to only display the user name and not include the hostname, add this config setting:

    echo 'bashrc.ps1.userhost=useronly' >>~/.bashrc.conf

## TODOs

* [x] ~add script to copy everything from this repo to the user's home directory and replace any mandatory absolute paths with correct ones~
* [x] ~change configuration to not rely on the presence of git~
* [x] ~add devenv setup for simple containers to house used development tools~
* [ ] devenv to support podman

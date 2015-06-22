# Scripty Stuff
Just a collection of scripts and script-like things (configs, etc.) of which I want to keep track.

Default config files exist here (.vimrc, .tmux.conf, etc.) which source in file(s) from this repository to extend functionality. This provides a nice, simple quick start platform to get your environment configured. Run the following in your home directory (possibly on first ssh in) to setup a new box (this will overwrite any existing files):

    git clone https://github.com/squid314/.common-config.git
    cp .common-config/.{bash{_profile,rc},gitconfig,gitignore,inputrc,tmux.conf,vimrc} .

For vim setup, run the following to initially set up vundle:

    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

## TODOs

* add script to copy everything from this repo to the user's home directory and replace any mandatory absolute paths with correct ones

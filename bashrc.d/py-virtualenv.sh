# python virtualenv and virtualenvwrapper stuff

# virtualenvwrapper directory
export WORKON_HOME=~/dev/venvs
# load the wrapper
source /usr/local/bin/virtualenvwrapper_lazy.sh

# virtualenv aliases
# http://blog.doughellmann.com/2010/01/virtualenvwrapper-tips-and-tricks.html (with modifications)
alias v='workon'
alias v.d='deactivate'
#alias v.deactivate='deactivate'
alias v.ls='lsvirtualenv'
alias v.mk='mkvirtualenv'
alias v.rm='rmvirtualenv'
alias v.tmp='mktmpenv'
alias v.sw='workon'
#alias v.switch='workon'
alias v.add='add2virtualenv'
#alias v.add2virtualenv='add2virtualenv'
alias v.cd='cdvirtualenv'
alias v.cds='cdsitepackages'
#alias v.cdsitepackages='cdsitepackages'
alias v.lss='lssitepackages'
#alias v.lssitepackages='lssitepackages'

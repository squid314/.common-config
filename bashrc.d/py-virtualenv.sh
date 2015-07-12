# python virtualenv and virtualenvwrapper stuff

# allow explicit configuration of where the script is but fallback to searching the path
_virtualenvwrapper_script="${_VIRTUALENVWRAPPER_SCRIPT:-`which virtualenvwrapper.sh 2>&-`}"
if [ -r "$_virtualenvwrapper_script" ] ; then

# virtualenvwrapper directories
export WORKON_HOME=~/dev/venvs
export PROJECT_HOME=~/dev
# load the wrapper
source $_virtualenvwrapper_script

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

fi
unset _virtualenvwrapper_script

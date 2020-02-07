# packer.sh

# don't do anything if packer is not present
if ! type packer &>/dev/null ; then return ; fi

mkdir -p "$HOME/.packer/cache"
export PACKER_CONFIG="$HOME/.packer/config"
export PACKER_CACHE_DIR="$HOME/.packer/cache"
export CHECKPOINT_DISABLE="1"

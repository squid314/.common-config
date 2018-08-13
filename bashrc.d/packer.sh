# packer.sh

# don't do anything if packer is not present
if ! which packer >&- 2>&- ; then return ; fi

mkdir -p "$HOME/.packer/cache"
export PACKER_CONFIG="$HOME/.packer/config"
export PACKER_CACHE_DIR="$HOME/.packer/cache"
export CHECKPOINT_DISABLE="1"

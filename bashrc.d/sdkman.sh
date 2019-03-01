# sdk.sh
# script to source the sdkman tool (formerly gvm)

if [[ -r "$HOME/.sdkman/bin/sdkman-init.sh" ]] ; then
    export SDKMAN_DIR="$HOME/.sdkman"
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

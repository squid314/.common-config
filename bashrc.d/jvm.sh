# jvm.sh

# gvm/nvm/rvm-style version switcher for the jdk. operates by updating the JAVA_HOME environment variable.

jvm() {
    # no args will simply display the current version (should we select a "default" version?)
    if [ $# = 0 ] ; then
        echo JAVA_HOME=\""$JAVA_HOME"\"
        return 0
    fi

    # note, i only support 6, 7, 8, 9
    case "$1" in
        6|1.6) export JAVA_HOME="`/usr/libexec/java_home -v 1.6`" ;;
        7|1.7) export JAVA_HOME="`/usr/libexec/java_home -v 1.7`" ;;
        8|1.8) export JAVA_HOME="`/usr/libexec/java_home -v 1.8`" ;;
        9|1.9) export JAVA_HOME="`/usr/libexec/java_home -v 1.9`" ;;
        # from 10 on, java_home accepts a simple number, so i'll use that (actually, from 10 on, the correct version number is not 1.X, but just X)
        [12][0-9]) export JAVA_HOME="`/usr/libexec/java_home -v $1`" ;;
        # TODO given java's new versioning model, this could get problematic. v29 should be released in the end of 2027, so we can revisit it then.
        *) echo "Don't understand version '$1'" ; return 1 ;;
    esac
    # echo mirror of the export so that this could be used at the beginning of a cmd line, e.g "`jvm 6` java doIt"
    echo JAVA_HOME=\""$JAVA_HOME"\"
}

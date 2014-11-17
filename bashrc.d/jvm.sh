# jvm.sh

# gvm/nvm/rvm-style version switcher for the jdk. operates by updating the JAVA_HOME environment variable.

jvm() {
    # note, i only support 6, 7, 8
    case "$1" in
        6|1.6) export JAVA_HOME="`/usr/libexec/java_home -v 1.6`" ;;
        7|1.7) export JAVA_HOME="`/usr/libexec/java_home -v 1.7`" ;;
        8|1.8) export JAVA_HOME="`/usr/libexec/java_home -v 1.8`" ;;
        9|1.9) export JAVA_HOME="`/usr/libexec/java_home -v 1.9`" ;;
        *) echo "Don't understand version '$1'" ; return 1 ;;
    esac
    # echo mirror of the export so that this could be used at the beginning of a cmd line, e.g "`jvm 6` java doIt"
    echo JAVA_HOME=\""$JAVA_HOME"\"
}

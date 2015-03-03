# tvm.sh
# Tomcat enVironment Manager
# Meant to handle switching between various *installed* versions of Tomcat. Expects all Tomcat versions to live in $TOMCAT_ROOT, which defaults to ~/dev/tomcats.

tvm() {
    if [ $# != 0 ] && [ $# != 1 ] && [ $# != 2 ] ; then
        echo "Usage: $0 [-u|--unset] | version [instance-id]" >&2
        echo "    -u|--unset   remove the CATALINA_* variables from the environment" >&2
        echo "    version      the [fuzzy] version of tomcat desired; or \"-\" to unset tomcat info" >&2
        echo "    instance-id  (optional) the absolute id of a tomcat instance" >&2
        echo "" >&2
        echo "Updates the current environment to allow manipulation of the identified tomcat installation and instance. If the identified tomcat installation is \"-\", then all tomcat exports are removed and the environment is reset to not automatically run tomcat instances. Otherwise, the \$TOMCAT_ROOT (or ~/dev/tomcats) is searched for a directory matching the version identified. If found, the environment is configured to use that directory as the installation directory (i.e., as \$CATALINA_HOME). Additionally, if an instance identifier is specified as the second argument, then the directory \$CATALINA_HOME/insts/\$2 will be set as \$CATALINA_BASE" >&2
        return 5
    fi

    if [ $# = 0 ] || [ $# = 1 -a \( "x$1" = "x-u" -o "x$1" = "x--unset" \) ] ; then
        unset CATALINA_HOME CATALINA_BASE
        # it doesn't make sense for these to be used at the start of a command line, so we have no need to echo the command
        return 0
    fi

    local tomcat_root="${TOMCAT_ROOT:-$HOME/dev/tomcats}"
    local tomcat_dir="$tomcat_root/$1"
    # if the exact version specified does not exist, try to find the most recent one in that line
    if ! [[ -d "$tomcat_dir" ]] ; then
        tomcat_dir="$(ls -dt $tomcat_root/$1* | head -n 1)"
    fi
    # strip a final slash, just in case, because it looks ugly
    tomcat_dir="${tomcat_dir%%/}"
    # could not find a usable tomcat installation
    if ! [[ -d "$tomcat_dir" ]] ; then
        echo "Unable to find a Tomcat installation for version \"$1\". Best guess was \"$tomcat_dir\"." >&2
        return 1
    fi

    # instance config for shared installation
    local inst_dir
    if [ $# == 2 ] ; then
        # strip trailing slash from instance name
        inst_dir="${tomcat_dir}/insts/${2%%/}"
        if ! [ -d "$inst_dir" ] ; then
            echo "instance directory \"$inst_dir\" doesn't exist!" >&2
            return 1
        fi
    fi

    # export only after validating the instance info; otherwise leave the environment unchanged
    export CATALINA_HOME="$tomcat_dir"
    if [ "$inst_dir" ] ; then
        export CATALINA_BASE="$inst_dir"
    else
        unset CATALINA_BASE
    fi
    # echo values for use as an inline eval for cmd lines like: `tvm 7` tc start
    echo "CATALINA_HOME=\"$CATALINA_HOME\"${CATALINA_BASE:+ CATALINA_BASE=\"}$CATALINA_BASE${CATALINA_BASE:+\"}"
}

tc() {
    if [ $# = 0 ] ; then
        cat >&2 <<USAGE
Usage: tc (home|base|put|clean|purge|log|logs|<any catalina.sh command>) <other args>...
  cd commands:
    home:  cd to CATALINA_HOME
    base:  cd to CATALINA_BASE
  content management:
    put:   add war(s) to webapps/
    clean: rm -rf directories corresponding to wars in webapps/
    purge: rm -rf directories and corresponding wars in webapps/ and rm -rf tmp/* work/*
  logification:
    log:   less +F catalina.out or other log file in logs/
    logs:  cd to logs/
  edit files:
    props: edit \$home/conf/catalina.properties
    env:   edit \$base/bin/setenv.sh

    *:     fall through to catalina.sh
USAGE
        return 42
    fi
    case $1 in
        # simple cds
        home) cd "${CATALINA_HOME}" ;;
        base) cd "${CATALINA_BASE}" ;;

        # simple content management
        put) # add a war file to the instance (or update a war file)
            shift
            cp "$@" "${CATALINA_BASE:-${CATALINA_HOME}}/webapps"
            ;;
        clean) # delete any exploded webapps (don't touch non-war applications)
            # do this in a subshell so that we don't affect the PWD
            bash -c 'cd "${CATALINA_BASE}/webapps" && for war in *.war ; do rm -rf "${war%.war}" || break ; done'
            ;;
        purge) # delete any exploded webapps and the war file backing them (don't touch non-war applications)
            # do this in a subshell so that we don't affect the PWD
            bash -c 'cd "${CATALINA_BASE}/webapps" && for war in *.war ; do rm -rf "${war}" "${war%.war}" || break ; done'
            ;;

        # simple logification
        log) # less +F for catalina.out with highlighting on "Server startup"
            # look at catalina.out if there are no arguments
            if [ "$#" = 1 ] ; then
                # +F does "tail -f" and +/Server... highlights the note when the server finishes starting up
                less -S +F +'/Server startup
' "${CATALINA_BASE:-${CATALINA_HOME}}/logs/catalina.out"

            # if there is exactly 1 argument, then we expand it onto the CATALINA_BASE path
            elif [ "$#" = 2 ] ; then
                if [ -f "${CATALINA_BASE:-${CATALINA_HOME}}/logs/$2" ] ; then
                    less -S +G "${CATALINA_BASE:-${CATALINA_HOME}}/logs/$2"
                else
                    echo "Cannot find \"${CATALINA_BASE:-${CATALINA_HOME}}/logs/$2\"" >&2
                    return 1
                fi
            fi
            ;;
        logs) # go to the logs directory
            cd "${CATALINA_BASE:-${CATALINA_HOME}}/logs"
            ls -l
            ;;

        # edit some specific files
        props)
            ${EDITOR:-vim} "${CATALINA_HOME}/conf/catalina.properties"
            ;;
        env)
            ${EDITOR:-vim} "${CATALINA_BASE}/bin/setenv.sh"
            ;;

        *) # anything else just falls through to catalina.sh
            "${CATALINA_HOME}/bin/catalina.sh" "$@"
            ;;
    esac
}

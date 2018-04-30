if [ -x /usr/local/bin/vim ]; then
    EDITOR=/usr/local/bin/vim
elif [ -x /usr/bin/vim ]; then
    EDITOR=/usr/bin/vim
else
    EDITOR=vi
fi

export EDITOR
export PATH=/usr/local/bin:/usr/local/sbin:$PATH:~xistence/Applications/

alias edit=$EDITOR

function lsockets {
    lsof -a -c $1 -i -l -P
}

function activate {
    if [ -d ~/.ve/$1 ]; then
        echo "Activating $1 virtual environment"
        source ~/.ve/$1/bin/activate

        export GEM_HOME="$VIRTUAL_ENV/gems"
        export GEM_PATH=""
        export PATH=$PATH:"$GEM_HOME/bin"
    else
        echo "That virtual environment does not exist!"
    fi
}

function tabname {
  printf "\e]1;$1\a"
}

function winname {
  printf "\e]2;$1\a"
}

function random_string {
    cat /dev/urandom | env LC_CTYPE=C tr -cd 'a-fA-F0-9' | head -c $1
}

function start_smtpd {
    if [ ""$1 == "" ]; then
        PORT=25
    else
        PORT=$1
    fi
    python -m smtpd -n -c DebuggingServer localhost:$PORT
}

function run_gmalloc {
    # Sub shell
    (
    export MallocStackLogging=1
    export MallocCheckHeapStart=1000
    export MallocCheckHeapEach=100
    export MallocScribble=1
    export MallocPreScribble=1
    export MallocStackLoggingNoCompact=1

    $@)
}

export TOX_PATH=""

function tox {
    PYENV=$(type -p pyenv)

    if [ ""$TOX_PATH == "" -a -x $PYENV ]; then
        for pyv in $(pyenv versions --bare); do
            TOX_PATH="$(pyenv prefix $pyv)/bin:$TOX_PATH"
        done
    fi

    export TOX_PATH=$TOX_PATH

    env PATH="$TOX_PATH:$PATH" tox $@
}

_shutdown_sleep () {
    return 0
}

function sleep_countdown {
    _SLEEP_COUNT=$1

    trap _shutdown_sleep SIGINT

    while [ $_SLEEP_COUNT -gt 0 ]; do
        printf "Sleeping %d more seconds." $_SLEEP_COUNT
        sleep 1

        if [ $? != 0 ]; then
            trap SIGINT
            return 1
        else
            printf "\033[2K\r"
            _SLEEP_COUNT=$(( _SLEEP_COUNT - 1 ))
        fi
    done
    trap SIGINT
}

function run_forever {
    SLEEP_COUNT=$1
    shift
    while true; do
        $@
        sleep_countdown $SLEEP_COUNT

        if [ $? != 0 ]; then
            echo "To end loop, press ^C"
            sleep 1
        fi
    done
}

function count_redir {
    curl -L -I -D - -o /dev/null $1 | awk 'BEGIN { redir = 0; status = 200; } tolower($1) ~ /http/ { redir=redir+1; status=$2 } tolower($1) ~ /location:/ { print redir, status, $2 } END { print "Completed, with ", redir-1, "redirects. Final result: ", status }'
}

if [ -f ~/.bash_profile.local ]; then
    . ~/.bash_profile.local
fi

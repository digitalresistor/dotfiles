export EDITOR=/usr/bin/vim
export PATH=/usr/local/bin:$PATH:~xistence/Applications/

alias edit=$EDITOR

function lsockets {
    lsof -a -c $1 -i -l -P
}

function activate {
    if [ -d ~/.ve/$1 ]; then
        echo "Activating $1 virtual environment"
        source ~/.ve/$1/bin/activate
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

if [ -f ~/.bash_profile.local ]; then
    . ~/.bash_profile.local
fi

export EDITOR=/usr/bin/vim
export PATH=/usr/local/share/python:/usr/local/bin:$PATH:~xistence/Applications/:/usr/X11R6/bin
export SCONS_LIB_DIR=/usr/local/Cellar/scons/2.0.1/lib/scons

alias edit=$EDITOR

function activate {
    source ~/.ve/$1/bin/activate
}

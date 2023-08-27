#!/usr/bin/env zsh


PYENV=$(whence pyenv)

if [ ! -x $PYENV ];
then
    echo "pyenv must be installed!"
fi

if [ $# -lt 1 ];
then
    echo "Need to provide the Python version you want to use, available versions:"
    pyenv versions
    exit -1
fi

PYVERSION=$1

if [ ! -x ~/.pyenv/versions/$PYVERSION/bin/python ];
then
    echo "Unable to execute Python version: $PYVERSION"
    exit -2
fi

if [ -d ~/.ve/pytools ];
then
    echo -n "A virtualenv already exists. Press enter to continue"
    read
    rm -rf ~/.ve/pytools
fi

echo "Creating new virtualenv and upgrading pip"

~/.pyenv/versions/$PYVERSION/bin/python -mvenv ~/.ve/pytools
~/.ve/pytools/bin/pip install -U pip wheel

echo "Installing the Python tools"

~/.ve/pytools/bin/pip install -U \
    flake8 \
    black \
    flake8-bugbear \
    pyflakes \
    pylint \
    isort \
    mypy \
    tox

for bin in \
    flake8 \
    black \
    blackd \
    pyflakes \
    pylint \
    isort \
    tox \
    mypy;
do
    echo "Linking $bin into ~/Applications/"
    if [ ! -e ~/Applications/$bin ]; then
        ln -s ~/.ve/pytools/bin/$bin ~/Applications/$bin
    fi
done

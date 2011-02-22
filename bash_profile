# So used to typing edit from FreeBSD, just create an alias
alias edit=nano

# Reviewboard
alias pr='post-review --server=http://freebsd-test/ --username=bert.regeer -o'

# Set up an alias for vim
alias vim='/usr/bin/vim'

# The default editor is vim, we export using a full path to the binary because for some reason it will exit with -1 otherwise which will cause hg and svn commits to fail
export EDITOR=/usr/bin/vim

# Add MacPorts to my path
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

# I'm lazy, and qmake for some reason wants to use Xcode as the default build environment on Mac OS X.
alias qm='qmake -r -spec macx-g++'

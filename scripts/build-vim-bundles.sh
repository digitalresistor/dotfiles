#!/usr/bin/env zsh

if [ ! -d /usr/local/opt/macvim/MacVim.app ]; then
    echo "It looks like MacVim is not installed."
    echo ""
    echo "Try: brew install macvim"
fi

PYTHON=/usr/local/opt/$(otool -L /usr/local/opt/macvim/MacVim.app/Contents/MacOS/Vim | grep Python | awk '{ print $1 }' | awk -F "/" '{ print $5 }')/bin/python3
RUBY=/usr/local/opt/ruby/bin/ruby

echo "Found the following: "

echo "otool -L output: "
otool -L /usr/local/opt/macvim/MacVim.app/Contents/MacOS/Vim
echo ""
echo "Thus using: "
echo "Python: ${PYTHON}"
echo "Ruby: ${RUBY}"
echo ""

echo "If this looks reasonable, press enter to continue!"
read

# Build and configure YCM
echo "Building YouCompleteMe"

cd ~/dotfiles/vim/bundle/ycm
$PYTHON ./install.py --all

echo "Building Command T"
cd ~/dotfiles/vim/bundle/command-t/ruby/command-t/ext/command-t
make clean
$RUBY extconf.rb
make

echo "Updating the YouCompleteMe Python path"
cat > ~/.ycm.path << EOF
let g:ycm_path_to_python_interpreter="${PYTHON}"
EOF

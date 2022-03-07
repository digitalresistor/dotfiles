export PATH=~/.cargo/bin:~/go/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:$PATH:~/Applications

# De-dup PATH, there's weird interactions between .zshenv and /etc/profile that
# leaves a bunch of stuff riddled with duplicates, which makes the $PATH hard
# to parse manually
NEW_PATH=( )
PATH_ARR=(${(s.:.)PATH})

for PITEM in $PATH_ARR[@]; do
    if [[ ${NEW_PATH[(ie)$PITEM]} -gt ${#NEW_PATH} ]]; then
        NEW_PATH+=$PITEM
    fi
done

PATH=${(j.:.)NEW_PATH}
export PATH


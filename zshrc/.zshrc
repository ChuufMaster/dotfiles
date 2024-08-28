CONFIGS=$HOME/.config

source $CONFIGS/zshrc/init.zsh
CONFIG_ZSH=$CONFIGS/zshrc

FILES_STR=$(fd --glob '*.zsh' --exclude 'init.zsh' --exclude 'after.zsh' $CONFIGS/zshrc)
FILES=($(echo $FILES_STR | tr '\n' ' '))

for FILE in $FILES; do
    source $FILE
done


source $CONFIG_ZSH/after.zsh

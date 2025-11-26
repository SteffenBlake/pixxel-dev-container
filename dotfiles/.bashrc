# redirect interactive bash shells to use zsh instead
if [ -t 1 ] && [ "$SHELL" != "$(which zsh)" ]; then
    exec zsh
fi

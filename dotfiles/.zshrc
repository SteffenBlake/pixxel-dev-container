export ZSH=$(nix eval --raw /env#packages.x86_64-linux.default)/share/oh-my-zsh
source "$ZSH/oh-my-zsh.sh"
cd /workspace
# Only enter nix shell if not already inside it
if [[ -z "$IN_NIX_SHELL" ]]; then
    export IN_NIX_SHELL=1
    nix shell /env
fi

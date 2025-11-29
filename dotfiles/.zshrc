# Load latst oh-my-zsh
source $(ls -td /nix/store/*oh-my-zsh*/share/oh-my-zsh/oh-my-zsh.sh | head -1)

export DOTNET_HOME="$(dirname "$(readlink -f $(which dotnet))")"
export DOTNET_ROOT=$DOTNET_HOME

export PATH="/root/.dotnet/tools:$PATH"

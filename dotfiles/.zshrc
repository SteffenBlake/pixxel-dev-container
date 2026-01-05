# Load latst oh-my-zsh
source $(ls -td /nix/store/*oh-my-zsh*/share/oh-my-zsh/oh-my-zsh.sh | head -1)

# Dotnet
if [ -n "$NIX_ENABLE_DOTNET" ]; then
    export DOTNET_HOME="$(dirname "$(readlink -f $(which dotnet))")"
    export DOTNET_ROOT=$DOTNET_HOME
    export PATH="/root/.dotnet/tools:$PATH"
fi

# Android
if [ -n "$NIX_ENABLE_ANDROID" ]; then
    export ANDROID_HOME="$(dirname "$(dirname "$(dirname "$(dirname "$(readlink -f $(which sdkmanager))")")")")"
    export JAVA_HOME="$(dirname "$(dirname "$(readlink -f $(which java))")")"
fi

# ld-linux-x86-64.so.2 patch
if [ ! -f /lib64/ld-linux-x86-64.so.2 ]; then
    mkdir -p /lib64
    ln -s "$GLIBC_PATH/lib/ld-linux-x86-64.so.2" /lib64/ld-linux-x86-64.so.2
fi

# /bin/bash symlink fix
if [ ! -x /bin/bash ]; then
    ln -s "$(which bash)" /bin/bash
fi

export SHELL="$(which zsh)"

# enable Tmux nesting
export TMUX=''

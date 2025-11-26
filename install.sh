#!/usr/bin/env bash
set -e

# ------------------------------------------------------------
# ensure gum exists
# ------------------------------------------------------------
if ! command -v gum >/dev/null 2>&1; then
    echo "gum not found, installing..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
    sudo apt update && sudo apt install -y gum
fi
gum style --foreground 10 "✅ gum installed or already present"

# ------------------------------------------------------------
# check Nix installation
# ------------------------------------------------------------
if command -v nix >/dev/null 2>&1; then
    gum style --foreground 10 "✅ Nix is installed"
else
    gum confirm "Nix is not installed. Install it now?" && \
      sh <(curl -L https://nixos.org/nix/install)
    
    # Source nix profile so PATH is updated in current shell
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
    
    gum style --foreground 10 "✅ Nix installation complete"
fi

# ------------------------------------------------------------
# check Zsh
# ------------------------------------------------------------
if command -v zsh >/dev/null 2>&1; then
    gum style --foreground 10 "✅ Zsh is installed"
else
    gum confirm "Zsh not found. Install it?" && sudo apt install -y zsh
    gum style --foreground 10 "✅ Zsh installation complete"
fi

# ------------------------------------------------------------
# check Oh-My-Zsh
# ------------------------------------------------------------
if [ -d "${HOME}/.oh-my-zsh" ]; then
    gum style --foreground 10 "✅ Oh-My-Zsh is installed"
else
    gum confirm "Oh-My-Zsh not found. Install it?" && \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    gum style --foreground 10 "✅ Oh-My-Zsh installation complete"
fi

# ------------------------------------------------------------
# ensure Zsh is the default shell
# ------------------------------------------------------------
if [ "$SHELL" != "$(command -v zsh)" ]; then
    gum confirm "Zsh is not your default shell. Change it now?" && chsh -s "$(command -v zsh)"
    gum style --foreground 10 "✅ Default shell changed to Zsh"
else
    gum style --foreground 10 "✅ Zsh is already your default shell"
fi

# ------------------------------------------------------------
# check Tmux
# ------------------------------------------------------------
if command -v tmux >/dev/null 2>&1; then
    gum style --foreground 10 "✅ Tmux is installed"
else
    gum confirm "Tmux not found. Install it?" && sudo apt install -y tmux
    gum style --foreground 10 "✅ Tmux installation complete"
fi

# ------------------------------------------------------------
# check grep
# ------------------------------------------------------------
if command -v grep >/dev/null 2>&1; then
    gum style --foreground 10 "✅ grep is installed"
else
    gum confirm "grep not found. Install it?" && sudo apt install -y grep
    gum style --foreground 10 "✅ grep installation complete"
fi

# ------------------------------------------------------------
# check fzf
# ------------------------------------------------------------
if command -v fzf >/dev/null 2>&1; then
    gum style --foreground 10 "✅ fzf is installed"
else
    gum confirm "fzf not found. Install it?" && sudo apt install -y fzf
    gum style --foreground 10 "✅ fzf installation complete"
fi

# ------------------------------------------------------------
# ensure Nix experimental features for flakes
# ------------------------------------------------------------
NIX_CONF="$HOME/.config/nix/nix.conf"
if [ ! -f "$NIX_CONF" ] || ! grep -q "experimental-features.*flakes" "$NIX_CONF"; then
    gum confirm "Nix experimental features for flakes are not enabled. Enable now?" && \
    mkdir -p "$(dirname "$NIX_CONF")" && \
    echo "experimental-features = nix-command flakes" >> "$NIX_CONF"
    gum style --foreground 10 "✅ Nix experimental features enabled"
else
    gum style --foreground 10 "✅ Nix experimental features already enabled"
fi

# ------------------------------------------------------------
# ensure Docker is installed
# ------------------------------------------------------------
gum spin --spinner dot --title "Checking Docker installation" -- \
  command -v docker >/dev/null 2>&1

if ! command -v docker >/dev/null 2>&1; then
    gum confirm "Docker not found. Install it?" && \
      sudo apt update && \
      sudo apt install -y ca-certificates curl && \
      sudo install -m 0755 -d /etc/apt/keyrings && \
      sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
      sudo chmod a+r /etc/apt/keyrings/docker.asc && \
      sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
      sudo apt update && \
      sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    gum style --foreground 10 "✅ Docker installed"
else       
    gum style --foreground 10 "✅ Docker already enabled"
fi

# ------------------------------------------------------------
# build the dev container image
# ------------------------------------------------------------
gum spin --spinner dot --title "Building dev container image" -- \
  docker build -t pixxel-dev-container ./


# ------------------------------------------------------------
# Finished
# ------------------------------------------------------------
gum style --foreground 10 "🎉 Backplane prerequisites verified."


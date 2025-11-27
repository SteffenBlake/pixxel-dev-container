FROM nixos/nix:latest

# Enable nix-command experimental feature
RUN mkdir -p /root/.config/nix && \
    echo "experimental-features = nix-command flakes" > /root/.config/nix/nix.conf

# Copy core.nix into the container
COPY core.nix /env/core.nix

# Copy dotfiles
COPY ./dotfiles/ /root/
RUN chown -R root:root /root

# Mount project .nix files at runtime
VOLUME /env
VOLUME /workspace

# Neovim setup
RUN mkdir -p /root/.config
#COPY ./neovim/ /root/.config/nvim/

# Load Nix and build environment, then start shell
CMD /bin/sh -c "\
    . /root/.nix-profile/etc/profile.d/nix.sh && \
    nix build /env#devShell.x86_64-linux && \
    touch /tmp/nix-ready && \
    tail -f /dev/null"

# Healthcheck: container healthy once /tmp/nix-ready exists
HEALTHCHECK --interval=5s --timeout=2s --retries=60 \
  CMD test -f /tmp/nix-ready || exit 1

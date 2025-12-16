{
  description = "Project dev environment (minimal flake)";

  inputs.nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

  outputs = { self, nixpkgs }: {
    devShell.x86_64-linux = import ./core.nix {
      inherit nixpkgs;
      enableRust = true;
      enableDotnet10 = true;
    };
  };
}

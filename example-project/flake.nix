{
  description = "Project dev environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default = import ./core.nix {
      inherit nixpkgs;
      enableDotnet = true;
    };
  };
}

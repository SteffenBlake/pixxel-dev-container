{
  description = "Project dev environment (minimal flake)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }: {
    devShell.x86_64-linux = import ./core.nix {
      inherit nixpkgs;
      enableDotnet9 = true;
      enableNodeJs22 = true;
      enableSvelte = true;
    };
  };
}

{ 
  nixpkgs ? import <nixpkgs> {},
  dotnetVersion ? null,
  enableNpm ? false
}:

let
  pkgs = nixpkgs.legacyPackages.x86_64-linux;
  lib = pkgs.lib;

  corePackages = [
    pkgs.iconv
    pkgs.zsh
    pkgs.oh-my-zsh
    pkgs.gawk
    pkgs.procps
    pkgs.coreutils
    pkgs.neovim
    pkgs.tmux
    pkgs.tmuxinator
    pkgs.fzf
    pkgs.lazygit
    pkgs.docker
  ];

  dotnetPkg =
    if dotnetVersion == 7 then pkgs.dotnet-sdk_7
    else if dotnetVersion == 8 then pkgs.dotnet-sdk
    else if dotnetVersion == 9 then pkgs.dotnet-sdk_9
    else if dotnetVersion == 10 then pkgs.dotnet-sdk_10
    else null;

  extraPackages = lib.concatLists [
    (if dotnetPkg != null then [ dotnetPkg ] else [])
    (if enableNpm then [ pkgs.nodejs ] else [])
  ];

  shellHookParts = lib.concatLists [
    (if dotnetVersion != null then [ "export NIX_DOTNET_VERSION=${toString dotnetVersion}" ] else [])
    ["exec zsh"]    
  ];

  shellHook = builtins.concatStringsSep "\n" shellHookParts;

in pkgs.mkShell {
  packages = corePackages ++ extraPackages;
  inherit shellHook;
}

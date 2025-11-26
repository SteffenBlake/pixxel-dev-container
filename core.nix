{ 
  nixpkgs ? import <nixpkgs> {},
  enableDotnet ? false,
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

  extraPackages = lib.concatLists [
    (if enableDotnet then [ pkgs.dotnet-sdk ] else [])
    (if enableNpm then [ pkgs.nodejs ] else [])
  ];

in pkgs.buildEnv {
  name  = "project-environment";
  paths = corePackages ++ extraPackages;
}

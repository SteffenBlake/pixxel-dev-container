{ 
  nixpkgs ? import <nixpkgs> {},

  # Languages

  ## Dotnet
  enableDotnet7 ? false,
  enableDotnet8 ? false,
  enableDotnet9 ? false,
  enableDotnet10 ? false,

  ## NodeJs
  enableNodeJs20 ? false,
  enableNodeJs22 ? false,
  enableNodeJs24 ? false,

  ## Typescript
  enableTypescript ? false,

  ## Rust
  enableRust ? false,

  # FE Frameworks
  enableSvelte ? false,
  enableVue ? false,
  enableAngular ? false,
  enableReact ? false
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
    pkgs.delta
    pkgs.lazygit
    pkgs.docker
    pkgs.openssh
    pkgs.ncurses
  ];

  enableDotnet = lib.any (x: x) [
    enableDotnet7
    enableDotnet8
    enableDotnet9
    enableDotnet10
  ];

  enableNodeJs = lib.any (x: x) [
    enableNodeJs20
    enableNodeJs22
    enableNodeJs24
  ];


  extraPackages = lib.concatLists [
    (if enableDotnet7 then [ pkgs.dotnet-sdk_7 ] else [])
    (if enableDotnet8 then [ pkgs.dotnet-sdk ] else [])
    (if enableDotnet9 then [ pkgs.dotnet-sdk_9 ] else [])
    (if enableDotnet10 then [ pkgs.dotnet-sdk_10 ] else [])
    # install Roslyn+netcoredbg regardless of versions
    (if enableDotnet then [ pkgs.roslyn-ls pkgs.netcoredbg ] else []) 

    (if enableNodeJs20 then [ pkgs.nodejs_20 ] else [])
    (if enableNodeJs22 then [ pkgs.nodejs_22 ] else [])
    (if enableNodeJs24 then [ pkgs.nodejs_24 ] else [])

    (if enableRust then [ 
        pkgs.rustc
        pkgs.cargo
        pkgs.rust-analyzer
        pkgs.lldb
    ] else [])
  ];

  shellHookParts = lib.concatLists [
    (if enableDotnet then [ "export NIX_ENABLE_DOTNET=1" ] else [])

    (if enableNodeJs then [ "export NIX_ENABLE_NODEJS=1" ] else [])
    (if enableTypescript then [ "export NIX_ENABLE_TS=1" ] else [])
    (if enableSvelte then [ "export NIX_ENABLE_SVELTE=1" ] else [])
    (if enableVue then [ "export NIX_ENABLE_VUE=1" ] else [])
    (if enableAngular then [ "export NIX_ENABLE_ANGULAR=1" ] else [])
    (if enableReact then [ "export NIX_ENABLE_REACT=1" ] else [])

    (if enableRust then [ "export NIX_ENABLE_RUST=1" ] else [])

    ["cd /workspace"]    
    ["exec zsh"]    
  ];

  shellHook = builtins.concatStringsSep "\n" shellHookParts;

in pkgs.mkShell {
  packages = corePackages ++ extraPackages;
  inherit shellHook;
}

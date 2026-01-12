{ 
  nixpkgs ? import <nixpkgs> {},

  # Languages

  ## Dotnet
  enableDotnet7 ? false,
  enableDotnet8 ? false,
  enableDotnet9 ? false,
  enableDotnet10 ? false,

  ## Android
  android-nixpkgs ? null,
  enableAndroid33 ? false,
  enableAndroid34 ? false,
  enableAndroid35 ? false,
  enableAndroid36 ? false,

  enableMonogame ? false,

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
  enableReact ? false,

  # Hugo
  enableHugo ? false
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
    pkgs.fzf
    pkgs.delta
    pkgs.lazygit
    pkgs.docker
    pkgs.openssh
    pkgs.ncurses
    pkgs.unzip
    pkgs.ripgrep
    pkgs.gum
  ];

  enableDotnet = lib.any (x: x) [
    enableDotnet7
    enableDotnet8
    enableDotnet9
    enableDotnet10
  ];

  enableAndroid = lib.any (x: x) [
    enableAndroid33
    enableAndroid34
    enableAndroid35
    enableAndroid36
  ];


  enableNodeJs = lib.any (x: x) [
    enableNodeJs20
    enableNodeJs22
    enableNodeJs24
  ];

  android-nixpkgs = pkgs.callPackage (import (builtins.fetchGit {
    url = "https://github.com/tadfisher/android-nixpkgs.git";
    rev = "9b0e6e2cac82807516bce87a12289980bf180fde";
  })) { channel = "stable"; };

  extraPackages = lib.concatLists [
    (if enableDotnet then [
      (
        with pkgs.dotnetCorePackages;
        combinePackages (
          lib.concatLists [
            (if enableDotnet7 then [ sdk_7_0 ] else [])
            (if enableDotnet8 then [ sdk_8_0 ] else [])
            (if enableDotnet9 then [ sdk_9_0 ] else [])
            (if enableDotnet10 then [ sdk_10_0 ] else [])
          ]
        )
      )
      pkgs.roslyn-ls
      pkgs.netcoredbg
    ] else [])

    (if enableAndroid then [
      (pkgs.androidenv.composeAndroidPackages {
        platformVersions = lib.concatLists [
          (if enableAndroid33 then [ "33" ] else [])
          (if enableAndroid34 then [ "34" ] else [])
          (if enableAndroid35 then [ "35" ] else [])
          (if enableAndroid36 then [ "36" ] else [])
        ];
        includeNDK = true;
      }).androidsdk
      pkgs.android-tools
      pkgs.javaPackages.compiler.openjdk17
    ] else [])

    (if enableDotnet && enableAndroid then [
      (pkgs.callPackage (builtins.fetchGit {
        url = "https://github.com/SteffenBlake/vscode-mono-debug-server.git";
        rev = "a873ce110903030e9bd45f349f28d3f1a8c7ea78";
        submodules = true;
      }) {})
    ] else [])

    (if enableMonogame then [
        pkgs.p7zip
        pkgs.wine
        pkgs.wine64
        pkgs.xorg.xvfb
        pkgs.fontconfig
    ] else [])

    (if enableNodeJs20 then [ pkgs.nodejs_20 ] else [])
    (if enableNodeJs22 then [ pkgs.nodejs_22 ] else [])
    (if enableNodeJs24 then [ pkgs.nodejs_24 ] else [])

    (if enableRust then [ 
        pkgs.rustc
        pkgs.cargo
        pkgs.rust-analyzer
        pkgs.lldb
    ] else [])

    (if enableHugo then [ pkgs.hugo ] else [])
  ];

  shellHookParts = lib.concatLists [
    (if enableDotnet7 then [ "export NIX_ENABLE_DOTNET_7=1" ] else [])
    (if enableDotnet8 then [ "export NIX_ENABLE_DOTNET_8=1" ] else [])
    (if enableDotnet9 then [ "export NIX_ENABLE_DOTNET_9=1" ] else [])
    (if enableDotnet10 then [ "export NIX_ENABLE_DOTNET_10=1" ] else [])
    (if enableDotnet then [ "export NIX_ENABLE_DOTNET=1" ] else [])
    (if enableAndroid then [ "export NIX_ENABLE_ANDROID=1" ] else [])
    (if enableMonogame then [ "export NIX_ENABLE_MONOGAME=1" ] else [])
    (if enableNodeJs then [ "export NIX_ENABLE_NODEJS=1" ] else [])
    (if enableTypescript then [ "export NIX_ENABLE_TS=1" ] else [])
    (if enableSvelte then [ "export NIX_ENABLE_SVELTE=1" ] else [])
    (if enableVue then [ "export NIX_ENABLE_VUE=1" ] else [])
    (if enableAngular then [ "export NIX_ENABLE_ANGULAR=1" ] else [])
    (if enableReact then [ "export NIX_ENABLE_REACT=1" ] else [])

    (if enableRust then [ "export NIX_ENABLE_RUST=1" ] else [])

    [ "export GLIBC_PATH=${pkgs.glibc}" ]
    [ "cd /workspace" ]    
    [ "exec zsh" ]    
  ];

  shellHook = builtins.concatStringsSep "\n" shellHookParts;

in pkgs.mkShell {
  packages = corePackages ++ extraPackages;
  inherit shellHook;
}

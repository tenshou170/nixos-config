{
  config,
  inputs,
  lib,
  pkgs,

  ...
}:

{

  # Development environment configuration
  environment.systemPackages = with pkgs; [
    # Rust development tools
    (inputs.fenix.packages.${pkgs.stdenv.hostPlatform.system}.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer

    # Python with development packages
    (python3.withPackages (
      ps: with ps; [
        pip
        black
        flake8
        mypy
        pytest
        requests
        numpy
        pandas
        python-lsp-server
        pylsp-mypy
        python-lsp-black
      ]
    ))

    # More development languages
    go

    # Core development tools
    jdk
    gcc
    cachix
    clang
    cmake
    devenv
    gnumake
    gdb
    dotnet-sdk
    mono
    pkg-config

    # Code editors and IDEs
    jetbrains.pycharm-community-bin
    (vscode.override {
      commandLineArgs = [
        "--ozone-platform=wayland"
      ];
    }).fhs
    (antigravity.override {
      commandLineArgs = [
        "--ozone-platform=wayland"
      ];
    }).fhs
    zed-editor

    # Command line tools
    jq
    tree
    ripgrep
    fd
    bat
    gh
    direnv
    fakeroot
    git
    gh
    libcap
    sqlite
    nix-search-tv

    # Language servers and formatters
    nixd
    nixfmt
    clang-tools
    omnisharp-roslyn
    jdt-language-server
    yaml-language-server

    # JavaScript/Node.js development
    nodejs_24
    pnpm
  ];

  # Enable some development tools
  programs = {
    # Enable Java
    java = {
      enable = true;
      package = pkgs.jdk;
    };
    # Enable direnv
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };

  # Set development environment variables
  environment.sessionVariables = {
    # Rust
    RUST_BACKTRACE = "1";
    CARGO_HOME = "$HOME/.cargo";
    # Move target dir to user cache to avoid /tmp permission clashes and keep it persistent across reboots
    CARGO_TARGET_DIR = "$HOME/.cache/cargo-target";

    # .NET
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    DOTNET_ROOT = "${pkgs.dotnet-sdk}";

    # Java
    JAVA_HOME = "${pkgs.jdk}";

    # C/C++ - Use 'lib.getExe' for safer path resolution on Unstable
    CC = lib.getExe' pkgs.gcc "gcc";
    CXX = lib.getExe' pkgs.gcc "g++";

    # Node
    NODE_OPTIONS = "--max-old-space-size=4096";
  };
}

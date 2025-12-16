{
  aagl,
  config,
  inputs,
  lib,
  pkgs,
  sharedFonts,
  ...
}:

{
  # System packages
  environment.systemPackages = with pkgs; [
    # System utilities
    btop
    btrfs-progs
    colord
    dconf-editor
    dee
    dosfstools
    gammastep
    libsecret
    mtools
    ntfs3g
    seatd
    libunity
    libayatana-appindicator
    libappindicator-gtk2
    libappindicator-gtk3
    wl-clipboard

    # Media & Graphics
    pavucontrol
    ffmpegthumbnailer
    gdk-pixbuf
    icoextract
    icoutils
    imagemagick
    krita
    switcheroo
    webp-pixbuf-loader
    wpgtk
    xournalpp

    # Android tools
    android-tools
    heimdall

    # Communication
    (discord-ptb.override {
      withEquicord = true;
      commandLineArgs = [
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
        "--wayland-text-input-version=3"
      ];
    })
    zapzap

    # Web browsers
    # vivaldi has different overrides for both COSMIC and Plasma6
    # google-chrome has different overrides for both COSMIC and Plasma6 (Needed for Antigravity)
    vivaldi-ffmpeg-codecs

    # Gaming & Wine
    (bottles.override {
      removeWarningPopup = true;
    })
    heroic
    lutris
    mangohud
    goverlay
    protonplus
    steam
    steamcmd
    steam-run
    umu-launcher
    vkbasalt
    vkbasalt-cli
    wineWowPackages.fonts
    wineWowPackages.stagingFull
    winetricks

    # Emulations
    dosbox-x
    (_86Box-with-roms.override {
      unfreeEnableDiscord = true;
      unfreeEnableRoms = true;
    })

    # Nemo file manager and extensions
    file-roller
    nemo
    nemo-with-extensions
    nemo-python
    nemo-preview
    nemo-seahorse
    nemo-fileroller

    # Other programs
    gnome-boxes
    proton-authenticator

    # Productivity
    onlyoffice-desktopeditors
    qbittorrent

    # Archives & Tools
    rar
    p7zip
    unzip
    unrar
    equicord
    freetype
    varia
  ];

  # Environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_ENABLE_HARDWARE_ACCELERATION = "1";
  };

  # Services
  services.flatpak.enable = true;

  # XDG configuration
  xdg = {
    autostart.enable = true;
    icons.enable = true;
    menus.enable = true;
    mime.enable = true;
    portal.xdgOpenUsePortal = true;
    sounds.enable = true;
  };

  # Flatpak repo setup
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = "flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo";
  };

  # Programs configuration
  programs = {
    # Basic programs
    adb.enable = true;
    command-not-found.enable = true;
    chromium.enable = true;
    dconf.enable = true;
    appimage.enable = true;
    gamemode.enable = true;
    gamescope.enable = true;

    # Steam configuration
    steam = {
      enable = true;
      extraPackages =
        with pkgs;
        [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXcomposite
          libGL
          vulkan-loader
          libpulseaudio
          alsa-lib
          libkrb5
          systemd
          wayland
          libxkbcommon
        ]
        ++ sharedFonts;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
    };
    # An Anime Team Launchers
    honkers-railway-launcher.enable = true;
    honkers-launcher.enable = true;
    sleepy-launcher.enable = true;
  };
}

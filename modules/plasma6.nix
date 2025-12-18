{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Fix Plasma 6 lagging
  nixpkgs.overlays = lib.singleton (
    final: prev: {
      kdePackages = prev.kdePackages // {
        plasma-workspace =
          let

            # the package we want to override
            basePkg = prev.kdePackages.plasma-workspace;

            # a helper package that merges all the XDG_DATA_DIRS into a single directory
            xdgdataPkg = pkgs.stdenv.mkDerivation {
              name = "${basePkg.name}-xdgdata";
              buildInputs = [ basePkg ];
              dontUnpack = true;
              dontFixup = true;
              dontWrapQtApps = true;
              installPhase = ''
                mkdir -p $out/share
                ( IFS=:
                  for DIR in $XDG_DATA_DIRS; do
                    if [[ -d "$DIR" ]]; then
                      cp -r $DIR/. $out/share/
                      chmod -R u+w $out/share
                    fi
                  done
                )
              '';
            };

            # undo the XDG_DATA_DIRS injection that is usually done in the qt wrapper
            # script and instead inject the path of the above helper package
            derivedPkg = basePkg.overrideAttrs {
              preFixup = ''
                for index in "''${!qtWrapperArgs[@]}"; do
                  if [[ ''${qtWrapperArgs[$((index+0))]} == "--prefix" ]] && [[ ''${qtWrapperArgs[$((index+1))]} == "XDG_DATA_DIRS" ]]; then
                    unset -v "qtWrapperArgs[$((index+0))]"
                    unset -v "qtWrapperArgs[$((index+1))]"
                    unset -v "qtWrapperArgs[$((index+2))]"
                    unset -v "qtWrapperArgs[$((index+3))]"
                  fi
                done
                qtWrapperArgs=("''${qtWrapperArgs[@]}")
                qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "${xdgdataPkg}/share")
                qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
              '';
            };

          in
          derivedPkg;
      };
    }
  );

  # Enable Plasma 6 desktop environment
  services = {
    accounts-daemon.enable = true;
    desktopManager = {
      plasma6 = {
        enable = true;
        enableQt5Integration = true;
      };
    };
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        enableHidpi = true;
      };
    };
  };

  # Fingerprint authentication PAM setting for Plasma 6
  security.pam.services.kde-fingerprint.fprintAuth = true;

  # Package Exclusion
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
  ];

  # Essential programs
  environment.systemPackages =
    (with pkgs; [
      adwaita-fonts
      adwaita-icon-theme
      adw-gtk3
      bibata-cursors
      (colloid-icon-theme.override {
        schemeVariants = [ "default" ];
        colorVariants = [ "all" ];
      })
      (fluent-gtk-theme.override {
        themeVariants = [ "all" ];
        colorVariants = [ "standard" ];
        sizeVariants = [ "standard" ];
        tweaks = [
          "solid"
          "float"
        ];
      })
      vlc
      (
        (vivaldi.override {
          commandLineArgs = [
            "--ozone-platform=wayland"
            "--enable-wayland-ime"
            "--wayland-text-input-version=3"
          ];
        }).overrideAttrs
        (oldAttrs: {
          dontWrapQtApps = false;
          dontPatchELF = true;
          nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.kdePackages.wrapQtAppsHook ];
        })
      )
      (google-chrome.override {
        commandLineArgs = [
          "--ozone-platform=wayland"
          "--enable-wayland-ime"
          "--wayland-text-input-version=3"
        ];
      })

    ])
    ++ (with pkgs.kdePackages; [
      markdownpart
      alligator
      isoimagewriter
      kcmutils
      phonon-vlc
      sddm-kcm
      flatpak-kcm
      kdeplasma-addons
      plasma5support
      kjournald
      ksystemlog
      ocean-sound-theme
      qtstyleplugin-kvantum
    ])
    ++ (with pkgs.libsForQt5; [
      qtstyleplugin-kvantum
    ]);

  # XDG configuration
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common.default = "kde";
  };

  # KDE-specific environment variables
  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
  };

  # Plasma-specific options
  programs = {
    chromium.enablePlasmaBrowserIntegration = true;
    kdeconnect.enable = true;
  };
}

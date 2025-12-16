{
  config,
  lib,
  pkgs,
  ...
}:

{
  #Set location provider to geoclue2
  location.provider = "geoclue2";

  # Enable power management
  powerManagement.enable = true;

  services = {
    # Hardware and system optimization
    fstrim.enable = true;
    btrfs.autoScrub.enable = true;
    fwupd.enable = true;
    irqbalance.enable = true;
    thermald.enable = true;
    dbus.implementation = "broker";

    # UDisk configuration
    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };

    # Device management
    accounts-daemon.enable = true;
    envfs.enable = true;
    userborn.enable = true;

    # Geoclue2 configuration
    geoclue2 = {
      enable = true;
      geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
      submissionUrl = "https://api.beacondb.net/v2/geosubmit";
      submissionNick = "geoclue";

      appConfig = {
        gammastep = {
          isAllowed = true;
          isSystem = false;
        };
        vivaldi = {
          isAllowed = true;
          isSystem = false;
        };
      };
    };

    # Printing services
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # seatd configuration
    seatd = {
      enable = true;
      user = "thshafi170";
    };

    # Desktop services
    tumbler.enable = true;
    timesyncd.enable = true;

    # X11 Display Server (Disabled, using Wayland)
    xserver = {
      enable = false;
      wacom.enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      excludePackages = with pkgs; [
        xterm
      ];
    };
  };
}

{
  inputs,
  pkgs,
  pkgsMaster,
  ...
}:

{
  # Home Manager module configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.tenshou170 = {
      # Basic home configuration
      home = {
        username = "tenshou170";
        homeDirectory = "/home/tenshou170";
        stateVersion = "26.05";
      };

      # Enable home-manager self-management
      programs.home-manager.enable = true;

      # XDG user directories configuration
      xdg.userDirs = {
        enable = true;
        createDirectories = true;
      };

      # Git configuration
      programs.git = {
        enable = true;
        lfs.enable = true;
        settings.user = {
          name = "Tenshou Zmeyev";
          email = "tenshou170@gmail.com";
        };
      };
    };

    # Pass extra special args to home-manager
    extraSpecialArgs = {
      inherit
        inputs
        pkgsMaster
        ;
    };
  };
}

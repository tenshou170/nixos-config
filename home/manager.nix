{
  inputs,
  pkgs,
  pkgsMaster,
  ...
}:

{
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
}

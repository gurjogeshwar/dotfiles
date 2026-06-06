{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  imports = [
    ../../home
    ./secrets
  ];

  versionControl.git.enable = true;
  shell = {
    zsh.enable = true;
    tools = {
      enable = true; # default tools (nh, btop, eza)
      starship.enable = true;
      direnv.enable = true;
      fastfetch.enable = true;
      bat.enable = true;
    };
  };
  editors = {
    neovim.enable = true;
  };

  desktop.hyprland.enable = true;
  desktop.vicinae.enable = true;
  desktop.waybar.enable = true;
  desktop.swaync.enable = true;
  desktop.swayosd.enable = true;

  home.username = "gaurav";
  home.homeDirectory = "/home/gaurav";

  home.packages = [ ];
  home.file = { };
  xdg.userDirs = {
    enable = true;
    createDirectories = true; # This is the key part
  };

  home.customDirs = [
    ".config/sops/age"
    "personal"
    "personal/media"
    "personal/projects"
    "personal/playground"
    "workspace"
  ];

  programs.home-manager.enable = true;
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  home.stateVersion = "26.11"; # Please read the comment before changing.
}

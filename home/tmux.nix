{
  myLib,
  config,
  pkgs,
  lib,
  ...
}:
myLib.mkHomeModule {
  globalConfig = config;
  name = "cli.tmux";
  description = "Tmux with custom dotfiles symlink";
  config = {
    home.packages = with pkgs; [
      sesh
      tmuxinator
      yq
    ];
    programs.tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        sessionist
      ];
      # HM writes ~/.tmux.conf which just hands control to the symlinked config below.
      extraConfig = ''source-file ~/.config/tmux/tmux.conf'';
    };

    home.file.".config/tmux".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/tmux";
  };
}

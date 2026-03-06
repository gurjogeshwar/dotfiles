{
  config,
  lib,
  ...
}:
{
  imports = [
    # Choose your theme here:
    ../../themes/zen.nix
  ];

  config.var = {
    hostname = "randy";
    username = "jogi";
    configDirectory = "/home/" + config.var.username + "/dotfiles"; # The path of the nixos configuration directory

    keyboardLayout = "us";

    location = "India";
    timeZone = "Asia/Kolkata";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "en_US.UTF-8";

    git = {
      username = "gurjogeshwar";
      email = "jogi123678@gmail.com ";
    };

    autoUpgrade = false;
    autoGarbageCollector = true;
  };

  # DON'T TOUCH THIS
  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}

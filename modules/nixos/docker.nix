{
  config,
  lib,
  ...
}:
lib.mkModule {
  globalConfig = config;
  name = "nixos.docker";
  description = "Docker container runtime";
  config = {
    virtualisation.docker.enable = true;
  };
}

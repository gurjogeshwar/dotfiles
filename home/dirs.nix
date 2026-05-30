{
  myLib,
  config,
  lib,
  ...
}:
let
  cfg = config.home.customDirs;
in
{
  options.home.customDirs = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = ''
      Directories (relative to $HOME) to create during Home Manager activation.
      Idempotent: existing paths are left alone.
    '';
    example = [
      "personal"
      "personal/projects"
      "workspace"
    ];
  };

  config = lib.mkIf (cfg != [ ]) {
    home.activation.createCustomDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      lib.concatMapStringsSep "\n" (d: ''$DRY_RUN_CMD mkdir -p "$HOME/${d}"'') cfg
    );
  };
}

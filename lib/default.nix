{ inputs }:
let
  baseLib = inputs.nixpkgs.lib;
  configHelper = import ./configHelper.nix { inherit inputs; };
  moduleHelper = import ./moduleHelper.nix { lib = baseLib; };
in
baseLib
// {
  # Merge our system strings into the standard lib.systems
  systems = baseLib.systems // configHelper.systems;

  # Shared font package list — call with `pkgs`.
  commonFontPkgs = import ./fonts.nix;

  # Flatten common helpers and metadata
  inherit (configHelper)
    forAllSystems
    standardOverlays
    overlays
    isDarwin
    mkPkgs
    mkNixosHost
    mkDarwinHost
    mkSystem
    mkHomeConfig
    mkConfigurations
    ;

  inherit (moduleHelper)
    mkModule
    mkHomeModule
    mkBoolOpt
    mkStrOpt
    mkPkgOpt
    ;
}

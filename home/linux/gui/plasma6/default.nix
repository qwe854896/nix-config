{
  config,
  lib,
  ...
} @ args:
with lib; let
  cfg = config.modules.desktop.plasma6;
in {
  imports = [
    ./options
  ];

  options.modules.desktop.plasma6 = {
    enable = mkEnableOption "Plasma 6 desktop environment";
    settings = lib.mkOption {
      type = with lib.types; let
        valueType =
          nullOr (oneOf [
            bool
            int
            float
            str
            path
            (attrsOf valueType)
            (listOf valueType)
          ])
          // {
            description = "Plasma 6 configuration value";
          };
      in
        valueType;
      default = {};
    };
  };

  config = mkIf cfg.enable (
    mkMerge ([
        {
          qt.kde.settings = cfg.settings;
        }
      ]
      ++ (import ./values args))
  );
}

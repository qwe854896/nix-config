# https://github.com/fufexan/dotfiles/blob/483680e121b73db8ed24173ac9adbcc718cbbc6e/system/programs/gamemode.nix
{
  config,
  pkgs,
  nix-gaming,
  lib,
  ...
}: let
  programs = lib.makeBinPath [
    pkgs.coreutils
    pkgs.power-profiles-daemon
  ];

  startscript = pkgs.writeShellScript "gamemode-start" ''
    export PATH=$PATH:${programs}
    powerprofilesctl set performance
  '';

  endscript = pkgs.writeShellScript "gamemode-end" ''
    export PATH=$PATH:${programs}
    powerprofilesctl set power-saver
  '';
in {
  # Optimise Linux system performance on demand
  # https://github.com/FeralInteractive/GameMode
  # https://wiki.archlinux.org/title/Gamemode
  #
  # Usage:
  #   1. For games/launchers which integrate GameMode support:
  #      https://github.com/FeralInteractive/GameMode#apps-with-gamemode-integration
  #      simply running the game will automatically activate GameMode.
  #   2. For others, launching the game through gamemoderun: `gamemoderun ./game`
  #   3. For steam: `gamemoderun steam-runtime`
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 15;
      };
      custom = {
        start = startscript.outPath;
        end = endscript.outPath;
      };
    };
  };

  # see https://github.com/fufexan/nix-gaming/#pipewire-low-latency
  services.pipewire.lowLatency.enable = true;
  imports = [
    nix-gaming.nixosModules.pipewireLowLatency
  ];
}

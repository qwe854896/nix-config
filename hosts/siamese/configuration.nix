{
  config,
  pkgs,
  sops-nix,
  lib,
  ...
}: {
  imports = [
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
    ../../modules/darwin
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # Load configuration that is shared across systems
  environment.systemPackages = with pkgs;
    [
      emacs-unstable
      sops-nix.packages."${pkgs.system}".default
    ]
    ++ (import ../../modules/shared/packages.nix {inherit pkgs;});

  launchd.user.agents.emacs.path = [config.environment.systemPath];
  launchd.user.agents.emacs.serviceConfig = {
    KeepAlive = true;
    ProgramArguments = [
      "/bin/sh"
      "-c"
      "/bin/wait4path ${pkgs.emacs}/bin/emacs && exec ${pkgs.emacs}/bin/emacs --fg-daemon"
    ];
    StandardErrorPath = "/tmp/emacs.err.log";
    StandardOutPath = "/tmp/emacs.out.log";
  };
}

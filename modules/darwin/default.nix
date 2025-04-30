{pkgs, ...}: {
  imports = [
    ./settings.nix
    ./homebrew.nix
  ];

  environment = {
    systemPackages =
      (import ./packages.nix {inherit pkgs;}) ++ (import ../shared/packages.nix {inherit pkgs;});
  };
}

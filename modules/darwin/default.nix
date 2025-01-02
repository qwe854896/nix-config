{pkgs, ...}: {
  imports = [
    ./settings.nix
    ./homebrew.nix
  ];

  environment = {
    etc = {
      terminfo = {
        # https://github.com/LnL7/nix-darwin/wiki/Terminfo-issues
        source = "${pkgs.ncurses}/share/terminfo";
      };
    };
    systemPackages = with pkgs;
      [
        # https://github.com/LnL7/nix-darwin/wiki/Terminfo-issues
        ncurses
      ]
      ++ (import ./packages.nix {inherit pkgs;})
      ++ (import ../shared/packages.nix {inherit pkgs;});
  };
}

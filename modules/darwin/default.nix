{pkgs, ...}: {
  imports = [
    ./settings.nix
    ./homebrew.nix
  ];

  # https://github.com/LnL7/nix-darwin/wiki/Terminfo-issues
  environment = {
    etc = {
      terminfo = {
        source = "${pkgs.ncurses}/share/terminfo";
      };
    };

    systemPackages = [
      pkgs.ncurses
    ];
  };
}

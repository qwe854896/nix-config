{
  config,
  pkgs,
  ...
}: {
  # set user's default shell system-wide
  users.defaultUserShell = pkgs.bashInteractive;

  # fix for `sudo xxx` in kitty/wezterm and other modern terminal emulators
  security.sudo.keepTerminfo = true;

  environment = {
    # add user's shell into /etc/shells
    shells = with pkgs; [
      bashInteractive
      fish
    ];

    variables = {
      # fix https://github.com/NixOS/nixpkgs/issues/238025
      TZ = "${config.time.timeZone}";
    };
  };

  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
  };

  programs = {
    # The OpenSSH agent remembers private keys for you
    # so that you don’t have to type in passphrases every time you make an SSH connection.
    # Use `ssh-add` to add a key to the agent.
    ssh.startAgent = true;
    # dconf is a low-level configuration system.
    dconf.enable = true;
  };
}

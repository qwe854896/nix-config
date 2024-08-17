{
  pkgs,
  myvars,
  nixpkgs,
  lib,
  ...
} @ args: {
  nix = {
    # auto upgrade nix to the unstable version
    package = pkgs.nixVersions.latest;

    # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
    registry.nixpkgs.flake = nixpkgs;

    # make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
    # discard all the default paths, and only use the one from this flake.
    nixPath = lib.mkForce ["/etc/nix/inputs"];

    settings = {
      # enable flakes globally
      experimental-features = ["nix-command" "flakes"];

      # given the users in this list the right to specify additional substituters via:
      #    1. `nixConfig.substituers` in `flake.nix`
      #    2. command line args `--options substituers http://xxx`
      trusted-users = [myvars.username];

      # https://github.com/NixOS/nix/issues/9574
      nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";

      # TODO: consider using substitutes from the cache
    };
  };

  # TODO: separate the following into a new module
  environment = {
    # make `nix shell` use the same nixpkgs as the one used by this flake.
    etc."nix/inputs/nixpkgs".source = "${nixpkgs}";

    systemPackages = with pkgs; [
      git # used by nix flakes
      git-lfs

      # archives
      zip
      xz
      zstd
      unzipNLS
      p7zip

      # Text Processing
      # Docs: https://github.com/learnbyexample/Command-line-text-processing
      gnugrep # GNU grep, provides `grep`/`egrep`/`fgrep`
      gnused # GNU sed, very powerful(mainly for replacing text in files)
      gawk # GNU awk, a pattern scanning and processing language
      jq # A lightweight and flexible command-line JSON processor

      # networking tools
      mtr # A network diagnostic tool
      iperf3
      dnsutils # `dig` + `nslookup`
      ldns # replacement of `dig`, it provide the command `drill`
      wget
      curl
      aria2 # A lightweight multi-protocol & multi-source command-line download utility
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      ipcalc # it is a calculator for the IPv4/v6 addresses

      # misc
      file
      findutils
      which
      tree
      gnutar
      rsync
    ];
  };

  # Overlays
  nixpkgs.overlays = import ../overlays args;

  users.users.${myvars.username} = {
    description = myvars.userfullname;
    # TODO:
    # Public Keys that can be used to login to all my PCs, Macbooks, and servers.
    #
    # Since its authority is so large, we must strengthen its security:
    # 1. The corresponding private key must be:
    #    1. Generated locally on every trusted client via:
    #      ```bash
    #      # KDF: bcrypt with 256 rounds, takes 2s on Apple M2):
    #      # Passphrase: digits + letters + symbols, 12+ chars
    #      ssh-keygen -t ed25519 -a 256 -C "jhc@xxx" -f ~/.ssh/xxx`
    #      ```
    #    2. Never leave the device and never sent over the network.
    # 2. Or just use hardware security keys like Yubikey/CanoKey.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKHjmk95MME81Aiz/FoCoD5JOXJtzZkz9A9qmsOmrtI/ qwe854896@Jun-Hongs-MacBook-Air.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKyXA/HWHyHWJWJISArtghapZ2bxhh3mrfDzl+RUIHzf jhc@siber"
    ];
  };

  # TODO: add private PKI's CA certificate to the system-wide trust store.
}

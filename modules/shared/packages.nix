{pkgs}:
with pkgs; [
  # General packages for development and system management
  alacritty
  aspell
  aspellDicts.en
  bash-completion
  bat
  coreutils
  # search for files by name, faster than find
  fd
  # Interactively filter its input using fuzzy searching, not limit to filenames.
  fzf
  killall
  openssh
  # search for files by its content, replacement of grep
  ripgrep
  # A safe and ergonomic alternative to rm
  rip2
  sqlite

  # misc
  gnumake

  # productivity
  caddy # A webserver with automatic HTTPS via Let's Encrypt(replacement of nginx)
  croc # File transfer between computers securely and easily

  # A fast and polyglot tool for code searching, linting, rewriting at large scale
  # supported languages: only some mainstream languages currently(do not support nix/nginx/yaml/toml/...)
  ast-grep

  # Encryption and security tools
  age
  age-plugin-yubikey
  gnupg
  libfido2
  sops
  rclone

  # Cloud-related tools and SDKs
  docker
  docker-compose

  # Media-related packages
  emacs-all-the-icons-fonts
  dejavu_fonts
  ffmpeg
  font-awesome
  hack-font
  noto-fonts
  noto-fonts-emoji
  meslo-lgs-nf
  viu

  # Node.js development tools
  nodePackages.npm # globally install npm
  nodePackages.prettier
  nodejs

  # Python packages
  python3
  virtualenv

  # Text and terminal utilities
  htop
  hunspell
  jetbrains-mono
  tree
  tmux
  unrar
  unzip
  zsh-powerlevel10k

  # Disk utilities
  duf
  ncdu

  # Nix utilities
  nix-output-monitor
  hydra-check # check hydra(nix's build farm) for the build status of a package
  nix-index # A small utility to index nix store paths
  nix-init # generate nix derivation from url
  # https://github.com/nix-community/nix-melt
  nix-melt # A TUI flake.lock viewer
  # https://github.com/utdemir/nix-tree
  nix-tree # A TUI to visualize the dependency graph of a nix derivation

  # Misc utilities
  cowsay
  just
  tldr

  ### NixOS ###
  git # used by nix flakes
  git-lfs

  # archive
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
  gnutar
  rsync

  # TUI tools
  fastfetch
  neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

  # system call monitoring
  tcpdump # network sniffer
  lsof # list open files

  # system monitoring
  iftop
  btop
  sysbench

  # GUI tools
  moonlight-qt
  wl-clipboard

  ### From Home Manager ###
  sad # CLI search and replace, just like sed, but with diff preview.
  yq-go # yaml processor https://github.com/mikefarah/yq
  delta # A viewer for git and diff output
  lazygit # Git terminal UI.
  hyperfine # command-line benchmarking tool
  gping # ping, but with a graph(TUI)
  doggo # DNS client for humans
  du-dust # A more intuitive version of `du` in rust
  gdu # disk usage analyzer(replacement of `du`)
]

{pkgs}:
with pkgs; [
  # General packages for development and system management
  alacritty
  aspell
  aspellDicts.en
  bash-completion
  bat
  btop
  coreutils
  fastfetch
  fd
  fzf
  killall
  openssh
  ripgrep
  sqlite
  wget
  zip

  # Encryption and security tools
  age
  age-plugin-yubikey
  gnupg
  libfido2

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
  iftop
  jetbrains-mono
  jq
  neovim
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
  nix-index

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
  tree
  gnutar
  rsync

  # TUI tools
  fastfetch
  neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  just

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
]

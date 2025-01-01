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
]

{
  pkgs,
  lib,
  mysecrets,
  ...
}: let
  name = "Jun-Hong Cheng";
  user =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "jhcheng"
    else "jhc";
  email = "qwe854896@gmail.com";
in {
  # Let Home Manager install and manage itself.
  home-manager.enable = true;

  # https://discourse.nixos.org/t/slow-build-at-building-man-cache/52365
  man.generateCaches = false;

  # Shared shell configuration
  zsh = {
    enable = true;
    autocd = false;
    cdpath = ["~/.local/share/src"];
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./config;
        file = "p10k.zsh";
      }
    ];
    initExtraFirst = ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # Define variables for directories
      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      # Ripgrep alias
      alias search=rg -p --glob '!node_modules/*'  $@

      export ALTERNATE_EDITOR=""

      # nix shortcuts
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

      # pnpm is a javascript package manager
      # typos-ignore-next-line
      # alias on=pnpm
      alias px=pnpx

      # Use difftastic, syntax-aware diffing
      alias diff=difft

      # Always color ls and group directories
      alias ls='ls --color=auto'
    '';
  };

  fish = {
    enable = true;
  };

  git = {
    enable = true;
    ignores = ["*.swp"];
    userName = name;
    userEmail = email;
    includes = [
      {
        # use different email & name for work
        path = "~/work/.gitconfig";
        condition = "gitdir:~/work/";
      }
    ];
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "nvim --clean";
        autocrlf = "input";
      };
      # commit.gpgsign = true;
      pull.rebase = true;
      rebase.autoStash = true;
      trim.bases = "develop,master,main"; # for git-trim
      push.autoSetupRemote = true;
    };
    signing = {
      key = "97983B8C7078C5B8";
      signByDefault = true;
    };
    delta = {
      enable = true;
      options = {
        diff-so-fancy = true;
        line-numbers = true;
        true-color = "always";
        # features => named groups of settings, used to keep related settings organized
        # features = "";
      };
    };
    aliases = {
      # common aliases
      br = "branch";
      co = "checkout";
      st = "status";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      cm = "commit -m"; # commit via `git cm <message>`
      ca = "commit -am"; # commit all changes via `git ca <message>`
      dc = "diff --cached";

      amend = "commit --amend -m"; # amend commit message via `git amend <message>`
      unstage = "reset HEAD --"; # unstage file via `git unstage <file>`
      merged = "branch --merged"; # list merged(into HEAD) branches via `git merged`
      unmerged = "branch --no-merged"; # list unmerged(into HEAD) branches via `git unmerged`
      nonexist = "remote prune origin --dry-run"; # list non-exist(remote) branches via `git nonexist`

      # delete merged branches except master & dev & staging
      #  `!` indicates it's a shell script, not a git subcommand
      delmerged = ''! git branch --merged | egrep -v "(^\*|main|master|dev|staging)" | xargs git branch -d'';
      # delete non-exist(remote) branches
      delnonexist = "remote prune origin";

      # aliases for submodule
      update = "submodule update --init --recursive";
      foreach = "submodule foreach";
    };
  };

  vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-airline-themes
      vim-startify
      vim-tmux-navigator
    ];
    settings = {
      ignorecase = true;
    };
    extraConfig = ''
      "" General
      set number
      set history=1000
      set nocompatible
      set modelines=0
      set encoding=utf-8
      set scrolloff=3
      set showmode
      set showcmd
      set hidden
      set wildmenu
      set wildmode=list:longest
      set cursorline
      set ttyfast
      set nowrap
      set ruler
      set backspace=indent,eol,start
      set laststatus=2
      set clipboard=autoselect

      " Dir stuff
      set nobackup
      set nowritebackup
      set noswapfile
      set backupdir=~/.config/vim/backups
      set directory=~/.config/vim/swap

      " Relative line numbers for easy movement
      set relativenumber
      set rnu

      "" Whitespace rules
      set tabstop=8
      set shiftwidth=2
      set softtabstop=2
      set expandtab

      "" Searching
      set incsearch
      set gdefault

      "" Statusbar
      set nocompatible " Disable vi-compatibility
      set laststatus=2 " Always show the statusline
      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1

      "" Local keys and such
      let mapleader=","
      let maplocalleader=" "

      "" Change cursor on mode
      :autocmd InsertEnter * set cul
      :autocmd InsertLeave * set nocul

      "" File-type highlighting and configuration
      syntax on
      filetype on
      filetype plugin on
      filetype indent on

      "" Paste from clipboard
      nnoremap <Leader>, "+gP

      "" Copy from clipboard
      xnoremap <Leader>. "+y

      "" Move cursor by display lines when wrapping
      nnoremap j gj
      nnoremap k gk

      "" Map leader-q to quit out of window
      nnoremap <leader>q :q<cr>

      "" Move around split
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l

      "" Easier to yank entire line
      nnoremap Y y$

      "" Move buffers
      nnoremap <tab> :bnext<cr>
      nnoremap <S-tab> :bprev<cr>

      "" Like a boss, sudo AFTER opening the file to write
      cmap w!! w !sudo tee % >/dev/null

      let g:startify_lists = [
        \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      }
        \ ]

      let g:startify_bookmarks = [
        \ '~/.local/share/src',
        \ ]

      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1
    '';
  };

  alacritty = {
    enable = true;
    settings = {
      cursor = {
        style = {
          shape = "Block";
          blinking = "Always";
        };
        blink_timeout = 10;
      };

      window = {
        blur = true;
        opacity = 0.7;
        padding = {
          x = 4;
          y = 4;
        };
        decorations = "Transparent";
        class = {
          instance = "Alacritty";
          general = "Alacritty";
        };
      };

      font = {
        normal = {
          family = "MesloLGS NF";
          style = "Regular";
        };
        size = lib.mkMerge [
          (lib.mkIf pkgs.stdenv.hostPlatform.isLinux 10)
          (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin 14)
        ];
      };

      # terminal.shell = "${pkgs.zsh}/bin/zsh";
      terminal.shell = "${pkgs.fish}/bin/fish";

      colors = {
        primary = {
          background = "0x1f2528";
          foreground = "0xc0c5ce";
        };

        normal = {
          black = "0x1f2528";
          red = "0xec5f67";
          green = "0x99c794";
          yellow = "0xfac863";
          blue = "0x6699cc";
          magenta = "0xc594c5";
          cyan = "0x5fb3b3";
          white = "0xc0c5ce";
        };

        bright = {
          black = "0x65737e";
          red = "0xec5f67";
          green = "0x99c794";
          yellow = "0xfac863";
          blue = "0x6699cc";
          magenta = "0xc594c5";
          cyan = "0x5fb3b3";
          white = "0xd8dee9";
        };
      };
    };
  };

  ###########################################################
  #
  # Kitty Configuration
  #
  # Useful Hot Keys for Linux(replace `ctrl + shift` with `cmd` on macOS)):
  #   1. Increase Font Size: `ctrl + shift + =` | `ctrl + shift + +`
  #   2. Decrease Font Size: `ctrl + shift + -` | `ctrl + shift + _`
  #   3. And Other common shortcuts such as Copy, Paste, Cursor Move, etc.
  #
  ###########################################################
  kitty = {
    enable = true;
    # kitty has catppuccin theme built-in,
    # all the built-in themes are packaged into an extra package named `kitty-themes`
    # and it's installed by home-manager if `theme` is specified.
    themeFile = "Catppuccin-Mocha";
    font = {
      name = "JetBrainsMono Nerd Font";
      # use different font size on macOS
      size =
        if pkgs.stdenv.isDarwin
        then 14
        else 13;
    };

    # consistent with wezterm
    keybindings = {
      "ctrl+shift+m" = "toggle_maximized";
      "ctrl+shift+f" = "show_scrollback"; # search in the current window
    };

    settings = {
      background_opacity = "0.93";
      macos_option_as_alt = true; # Option key acts as Alt on macOS
      enable_audio_bell = false;
      tab_bar_edge = "top"; # tab bar on top
      #  To resolve issues:
      #    1. https://github.com/ryan4yin/nix-config/issues/26
      #    2. https://github.com/ryan4yin/nix-config/issues/8
      #  Spawn a fish in login mode via `bash`
      shell = "${pkgs.bash}/bin/bash --login -c 'fish --login --interactive'";
    };

    # macOS specific settings
    darwinLaunchOptions = ["--start-as=maximized"];
  };

  ssh = {
    enable = true;
    includes = [
      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux "/home/${user}/.ssh/config_external")
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "/Users/${user}/.ssh/config_external")
    ];
  };

  zellij = {
    enable = true;
    enableZshIntegration = false; # annoying
    enableFishIntegration = false; # annoying
    settings = {
      window.option_as_alt = "Both";
    };
  };

  # a cat(1) clone with syntax highlighting and Git integration.
  bat = {
    enable = true;
    config = {
      pager = "less -FR";
    };
  };

  # A modern replacement for ‘ls’
  eza = {
    enable = true;
    enableFishIntegration = true;
    git = true;
    icons = "auto";
  };

  # A command-line fuzzy finder
  fzf = {
    enable = true;
    # https://github.com/catppuccin/fzf
    # catppuccin-mocha
    colors = {
      "bg+" = "#313244";
      "bg" = "#1e1e2e";
      "spinner" = "#f5e0dc";
      "hl" = "#f38ba8";
      "fg" = "#cdd6f4";
      "header" = "#f38ba8";
      "info" = "#cba6f7";
      "pointer" = "#f5e0dc";
      "marker" = "#f5e0dc";
      "fg+" = "#cdd6f4";
      "prompt" = "#cba6f7";
      "hl+" = "#f38ba8";
    };
  };

  # zoxide is a smarter cd command, inspired by z and autojump.
  # It remembers which directories you use most frequently,
  # so you can "jump" to them in just a few keystrokes.
  # zoxide works on all major shells.
  #
  #   z foo              # cd into highest ranked directory matching foo
  #   z foo bar          # cd into highest ranked directory matching foo and bar
  #   z foo /            # cd into a subdirectory starting with foo
  #
  #   z ~/foo            # z also works like a regular cd command
  #   z foo/             # cd into relative path
  #   z ..               # cd one level up
  #   z -                # cd into previous directory
  #
  #   zi foo             # cd with interactive selection (using fzf)
  #
  #   z foo<SPACE><TAB>  # show interactive completions (zoxide v0.8.0+, bash 4.4+/fish/zsh only)
  zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    # enableFishIntegration = true;
  };

  gpg = {
    enable = true;
    homedir =
      if pkgs.stdenv.hostPlatform.isLinux
      then "/home/${user}/.gnupg"
      else if pkgs.stdenv.hostPlatform.isDarwin
      then "/Users/${user}/.gnupg"
      else "";

    publicKeys = [
      {
        # TODO: separate the config
        source = "${mysecrets}/public/jhcheng-gpg-keys-2034-09-03.pub";
        trust = 5;
      } # ultimate trust, my own keys.
    ];
    # This configuration is based on the tutorial below, it allows for a robust setup
    # https://blog.eleven-labs.com/en/openpgp-almost-perfect-key-pair-part-1
    # ~/.gnupg/gpg.conf
    settings = {
      # Get rid of the copyright notice
      no-greeting = true;

      # Disable inclusion of the version string in ASCII armored output
      no-emit-version = true;
      # Do not write comment packets
      no-comments = false;
      # Export the smallest key possible
      # This removes all signatures except the most recent self-signature on each user ID
      export-options = "export-minimal";

      # Display long key IDs
      keyid-format = "0xlong";
      # List all keys (or the specified ones) along with their fingerprints
      with-fingerprint = true;

      # Display the calculated validity of user IDs during key listings
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity show-keyserver-urls";

      # Select the strongest cipher
      personal-cipher-preferences = "AES256";
      # Select the strongest digest
      personal-digest-preferences = "SHA512";
      # This preference list is used for new keys and becomes the default for "setpref" in the edit menu
      default-preference-list = "SHA512 SHA384 SHA256 RIPEMD160 AES256 TWOFISH BLOWFISH ZLIB BZIP2 ZIP Uncompressed";

      # Use the strongest cipher algorithm
      cipher-algo = "AES256";
      # Use the strongest digest algorithm
      digest-algo = "SHA512";
      # Message digest algorithm used when signing a key
      cert-digest-algo = "SHA512";
      # Use RFC-1950 ZLIB compression
      compress-algo = "ZLIB";

      # Disable weak algorithm
      disable-cipher-algo = "3DES";
      # Treat the specified digest algorithm as weak
      weak-digest = "SHA1";

      # The cipher algorithm for symmetric encryption for symmetric encryption with a passphrase
      s2k-cipher-algo = "AES256";
      # The digest algorithm used to mangle the passphrases for symmetric encryption
      s2k-digest-algo = "SHA512";
      # Selects how passphrases for symmetric encryption are mangled
      s2k-mode = "3";
      # Specify how many times the passphrases mangling for symmetric encryption is repeated
      s2k-count = "65011712";
    };
  };

  password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [
      exts.pass-import
      exts.pass-update
      exts.pass-otp
    ]);
    settings = {
      # TODO: need to separate config
      PASSWORD_STORE_DIR =
        if pkgs.stdenv.hostPlatform.isLinux
        then "/home/${user}/.password-store"
        else if pkgs.stdenv.hostPlatform.isDarwin
        then "/Users/${user}/.password-store"
        else "";
      PASSWORD_STORE_KEY = "64DAB0AA";
      PASSWORD_SIGNING_KEY = "7078C5B8";
      PASSWORD_STORE_CLIP_TIME = "60";
    };
  };

  browserpass = {
    enable = true;
  };

  starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;

    settings = {
      character = {
        success_symbol = "[›](bold green)";
        error_symbol = "[›](bold red)";
      };
      aws = {
        symbol = "🅰 ";
      };
      gcloud = {
        # do not show the account/project's info
        # to avoid the leak of sensitive information when sharing the terminal
        format = "on [$symbol$active(\($region\))]($style) ";
        symbol = "🅶 ️";
      };
      command_timeout = 750;
    };
  };
}

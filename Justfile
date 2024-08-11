# just is a command runner, Justfile is very similar to Makefile, but simpler.

############################################################################
#
#  Nix commands related to the local machine
#
############################################################################

deploy:
  nixos-rebuild switch --flake . --use-remote-sudo

deploy-darwin:
  darwin-rebuild switch --flake .

debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose

debug-darwin:
  darwin-rebuild switch --flake . --show-trace --verbose

up:
  nix flake update

# Update specific input
# usage: make upp i=home-manager
upp:
  nix flake update $(i)

history:
  nix profile history --profile /nix/var/nix/profiles/system

repl:
  nix repl -f flake:nixpkgs

clean:
  # remove all generations older than 7 days
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

gc:
  # garbage collect all unused nix store entries
  sudo nix store gc --debug
  sudo nix-collect-garbage --delete-old

############################################################################
#
#  Neovim related commands
#
############################################################################

[group('neovim')]
nvim-test:
  rm -rf $"($HOME)/.config/nvim"
  rsync -avz --copy-links --chmod=D2755,F744 home/base/tui/editors/neovim/nvim/ $"$HOME/.config/nvim/"

[group('neovim')]
nvim-clean:
  rm -rf $"$HOME/.config/nvim"
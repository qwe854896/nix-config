# just is a command runner, Justfile is very similar to Makefile, but simpler.

############################################################################
#
#  Nix commands related to the local machine
#
############################################################################

os := `uname -s | grep -qi darwin && echo darwin || echo nixos`
hostname := `hostname`
sudo_flag := `[[ {{os}} == "nixos" ]] && echo --use-remote-sudo || echo`

build:
  nom build .#{{os}}Configurations.{{quote(hostname)}}.config.system.build.toplevel --show-trace --verbose

deploy:
  ./result/sw/bin/{{os}}-rebuild switch --flake . {{sudo_flag}}

debug:
  ./result/sw/bin/{{os}}-rebuild switch --flake . {{sudo_flag}} --show-trace --verbose

clean:
  # remove all generations older than 7 days
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

gc:
  # garbage collect all unused nix store entries
  sudo nix store gc --debug
  sudo nix-collect-garbage --delete-old

up:
  nix flake update

upp input:
  nix flake update {{input}}

# Jun-Hong Cheng's Nix Configuration

## Structure

The following are sorted by the order of complexity, from the simplest to the most complex.

- `Justfile`: A `Makefile`-like file for making simpler shorthands for common tasks.

- `vars`: Contains all personal information separated from the main configuration.

- `lib`: Contains some utility functions and wrappers for both NixOS and Nix-Darwin configuration
  makers.

- `overlays`: Store all overlays for Nix packages. I'm not using it now, since I'm not familiar with
  it.

- `flake.nix`: The entry point of the Nix configuration. Mainly contains all inputs of the flakes
  with outputs separated to configurations inside `outputs`.

- `outputs`: The main part to prepare the arguments for all submodules, separating hosts'
  configurations by their architecture (like `x86_64-linux` and `aarch64-darwin`), and composing
  needed submodules from `home`, `modules`, and `hosts` in each host.

- `hosts`: Store specific configurations for different hosts, including their own hardware
  configurations.

- `modules`: Group system-level configurations for NixOS servers, NixOS desktops, and Nix-Darwin
  macOS machines.

- `home`: Contains all user-level configurations by separating common ones and specific ones for
  both Linux and macOS. They are further divided by CLI tools, TUI tools, and GUI tools.

To see the details of how to add a new host, please refer to the `hosts`.

For adding new packages, please refer to `modules` and `home`, depending on which level you want to
add the package.

## References

- Most of the configuration is based on
  [Ryan4Yin's Nix Config](https://github.com/ryan4yin/nix-config) with some modifications.

- Special thanks to Ryan4Yin for his amazing
  [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/zh/) and elegant Nix configuration.

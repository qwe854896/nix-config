# Hosts

- `siber`: My main desktop with NixOS + i7-12700, for gaming and daily use. Currently, it lives in a
  KVM/QEMU virtual machine. The whole name is `Siberian-Cat`.

- `lix`: A Proxmox LXC container for testing NixOS configurations.

- `ipro`: Secret.

## How to Add a New Host

1. Under `hosts/`

   1. create a new directory with the name of the host.
   2. rename the `configuration.nix` to `default.nix` and place it in the new directory.
   3. move the `hardware-configuration.nix` to the new directory.
   4. if needed, consider adding `home.nix` for user-level configurations, and `impermanence.nix`
      for cool stuff.

2. Under `outputs/`
   1. add a new nix file named `<architecture>/src/<name>.nix` for the new host.
   2. usually, just copy the existing one and modify the host name.

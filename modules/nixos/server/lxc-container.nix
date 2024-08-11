{
  modulesPath,
  lib,
  ...
}: {
  imports = [
    "${toString modulesPath}/virtualisation/lxc-container.nix"
  ];

  config = {
    # disable backups in the VM
    services.btrbk.instances = lib.mkForce {};

    services.openssh.enable = true;

    # we configure the host via nixos itself, so we don't need the cloud-init
    services.cloud-init.enable = lib.mkForce false;

    # Related issue:
    #  "sys-kernel-debug.mount" fails when running nixos-rebuild switch in a Proxmox LXC
    #   https://github.com/NixOS/nixpkgs/issues/157918
    systemd.mounts = [
      {
        where = "/sys/kernel/debug";
        enable = false;
      }
    ];
  };
}

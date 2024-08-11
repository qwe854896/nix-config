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

    # enable serial console
    systemd.services."serial-getty@ttyS0".enable = true;
  };
}

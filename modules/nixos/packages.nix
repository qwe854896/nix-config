{pkgs}:
with pkgs; let
  shared-packages = import ../shared/packages.nix {inherit pkgs;};
in
  shared-packages
  ++ [
    # system monitoring
    iotop
    sysstat
    nmon

    # system call monitoring
    bpftrace # powerful tracing tool
    strace # system call monitoring
    ltrace # library call monitoring

    # system tools
    psmisc # killall/pstree/prtstat/fuser/...
    ethtool
    pciutils # lspci
    usbutils # lsusb
    dmidecode # a tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard
    hdparm # for disk performance, command
    lm_sensors # for `sensors` command
    parted

    # Nvidia related
    libva-utils
    vdpauinfo
    vulkan-tools
    vulkan-validation-layers
    libvdpau-va-gl
    egl-wayland
    wgpu-utils
    mesa
    libglvnd
    libGL
    nvtopPackages.full
    nvitop
    libGL
    conda
  ]
# environment.variables.EDITOR = "nvim";


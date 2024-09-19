{
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # security with gnome-kering
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  security.pam.services.hyprlock = {};

  # gpg agent with pinentry
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
    settings.default-cache-ttl = 4 * 60 * 60;
  };
}

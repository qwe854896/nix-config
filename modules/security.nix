{
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # gpg agent with pinentry
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
    settings.default-cache-ttl = 4 * 60 * 60;
  };
}

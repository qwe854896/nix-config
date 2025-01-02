{
  programs.dconf.enable = true;

  services.displayManager = {
    sddm.enable = true;
    autoLogin.enable = true;
    autoLogin.user = "jhc";
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
}

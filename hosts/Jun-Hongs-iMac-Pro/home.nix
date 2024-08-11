_: {
  programs.ssh = {
    enable = true;
    # TODO: Modify the following configuration to fit your needs.
    extraConfig = ''
      Host github.com
        Hostname github.com
        IdentityFile ~/.ssh/jun-hongs-ipro
        IdentitiesOnly yes
    '';
  };
}

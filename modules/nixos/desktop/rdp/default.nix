{
  pkgs,
  mylib,
  ...
}: {
  imports = mylib.scanPaths ./.;

  environment.systemPackages = with pkgs; [
    waypipe
    moonlight-qt # moonlight client, for streaming games/desktop from a PC
    rustdesk # p2p remote desktop
  ];

  # An workaround to use cursor in RDP
  # https://github.com/LizardByte/Sunshine/issues/93
  environment.variables.KWIN_FORCE_SW_CURSOR = 1;
}

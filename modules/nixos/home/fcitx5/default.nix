{pkgs, ...}: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      # for flypy chinese input method
      # needed enable rime using configtool after installed
      fcitx5-chinese-addons
      fcitx5-chewing
      fcitx5-gtk # gtk im module
    ];
  };
}

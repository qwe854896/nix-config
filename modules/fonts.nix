{pkgs, ...}: {
  # all fonts are linked to /nix/var/nix/profiles/system/sw/share/X11/fonts
  fonts = {
    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = with pkgs; [
      # icon fonts
      material-design-icons
      font-awesome

      # Noto 系列字體是 Google 主導的，名字的含義是「沒有豆腐」（no tofu），因為缺字時顯示的方框或者方框被叫作 tofu
      # Noto 系列字族名只支持英文，命名規則是 Noto + Sans 或 Serif + 文字名稱。
      # 其中漢字部分叫 Noto Sans/Serif CJK SC/TC/HK/JP/KR，最後一個詞是地區變種。
      # noto-fonts # 大部分文字的常見樣式，不包含漢字
      # noto-fonts-cjk # 漢字部分
      noto-fonts-emoji # 彩色的表情符號字體
      # noto-fonts-extra # 提供額外的字重和寬度變種

      # 思源系列字體是 Adobe 主導的。其中漢字部分被稱為「思源黑體」和「思源宋體」，是由 Adobe + Google 共同開發的
      source-sans # 無襯線字體，不含漢字。字族名叫 Source Sans 3 和 Source Sans Pro，以及帶字重的變體，加上 Source Sans 3 VF
      source-serif # 襯線字體，不含漢字。字族名叫 Source Code Pro，以及帶字重的變體
      source-han-sans # 思源黑體
      source-han-serif # 思源宋體

      # nerdfonts
      # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/data/fonts/nerdfonts/shas.nix
      (nerdfonts.override {
        fonts = [
          # symbols icon only
          "NerdFontsSymbolsOnly"
          # Characters
          "FiraCode"
          "JetBrainsMono"
          "Iosevka"
        ];
      })
      julia-mono
      dejavu_fonts
    ];

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = ["Source Han Serif SC" "Source Han Serif TC" "Noto Color Emoji"];
      sansSerif = ["Source Han Sans SC" "Source Han Sans TC" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  # https://wiki.archlinux.org/title/KMSCON
  services.kmscon = {
    # Use kmscon as the virtual console instead of gettys.
    # kmscon is a kms/dri-based userspace virtual terminal implementation.
    # It supports a richer feature set than the standard linux console VT,
    # including full unicode support, and when the video card supports drm should be much faster.
    enable = true;
    fonts = [
      {
        name = "Source Code Pro";
        package = pkgs.source-code-pro;
      }
    ];
    extraOptions = "--term xterm-256color";
    extraConfig = "font-size=12";
    # Whether to use 3D hardware acceleration to render the console.
    hwRender = true;
  };
}

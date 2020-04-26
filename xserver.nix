{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    libinput = {
      enable = true;
      disableWhileTyping = true;
      naturalScrolling = true;
      };
    autorun = true;
    desktopManager.xterm.enable = false;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [ i3blocks ];
    };

    displayManager = {
      defaultSession = "none+i3";
      lightdm = {
        enable = true;
        greeter.enable = false;
        autoLogin = {
          enable = true;
          user = "dooy";
        };
      };
    };
    
    desktopManager.xfce = {
      enable = true;
      thunarPlugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar_volman
        thunar-dropbox-plugin
      ];
      noDesktop = true;
    };

    xkbOptions = "caps:escape, grp:rctrl_rshift_toggle";
    xkbVariant = "workman,";
  };

  fonts = {
    fonts = with pkgs; [
      dejavu_fonts
      ubuntu_font_family
      iosevka
      fira-code
      terminus_font
      liberation_ttf
      fira-mono
      source-code-pro
    ];
    fontconfig = {
      subpixel.rgba = "none";
      subpixel.lcdfilter = "none";
    };
  };
}

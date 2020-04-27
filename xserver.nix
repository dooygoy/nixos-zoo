{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    libinput = {
      enable = true;
      disableWhileTyping = true;
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
    layout = "us, hr";
    xkbOptions = "caps:swapescape, grp:rctrl_rshift_toggle";
    xkbVariant = "workman,";
  };
  
  programs.dconf.enable = true;
  
  services.picom = {
    enable = true;
    fade = true;
    shadow = true;
    inactiveOpacity = "0.9";
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

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
    fadeDelta = 8;
    fadeSteps = [ "0.056" "0.06" ];
    shadow = true;
    shadowOpacity = "0.36";
    inactiveOpacity = "0.8";
    activeOpacity = "0.92";
    opacityRules = [
      "100:class_g ?= 'feh'"
      "100:class_g *?= 'Firefox'"
      "100:class_g *?= 'Nightly'"
      "92:class_g ?= 'Rofi'"
     # "100:class_g ?= 'Zathura'"
      "100:class_g ?= 'Gimp'"
      "100:class_g ?= 'Inkscape'"
      "100:class_g ?= 'Blender'"
      "100:class_g ?= 'vlc'"
      "100:class_g ?= 'mplayer'"
     ];
  };

  fonts = {
    fonts = with pkgs; [
      dejavu_fonts
      ubuntu_font_family
      iosevka
      fira-code
      terminus_font
      terminus_font_ttf
      liberation_ttf
      fira-mono
      source-code-pro
      source-serif-pro
      source-sans-pro
      noto-fonts-emoji
      font-awesome-ttf
    ];
    fontconfig = {
      subpixel.rgba = "none";
      subpixel.lcdfilter = "none";
      };
    };
}

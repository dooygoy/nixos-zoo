# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./boot.nix
    ./xserver.nix
    ./hardware-configuration.nix
    ./packages.nix
    (import "${
        builtins.fetchTarball
        "https://github.com/rycee/home-manager/archive/master.tar.gz"
      }/nixos")
  ];

  nixpkgs.config.allowUnfree = true;
  nix.trustedBinaryCaches = [ "http://hydra.nixos.org" ];

  networking = {
    hostName = "unimatrix";
    hostId = "765e22df";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.enp0s20f0u2.useDHCP = true;
    interfaces.wlo1.useDHCP = true;
  };

 # virtualisation = {
 #   docker = {
 #     enable = true;
 #     };

 #   libvirtd.enable = true;
 #   virtualbox = {
 #     host = {
 #       enable = true;
 #       enableExtensionPack = true;  
 #     };
 #     guest.enable = true;
 #   };
 # };

  # Set your time zone.
  time.timeZone = "Europe/Zagreb";

  services.lorri.enable = true;

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  services.compton = {
    enable = true;
    fade = true;
    inactiveOpacity = "0.9";
    shadow = true;
    fadeDelta = 4;
  };    
    
  users.extraUsers.dooy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "vboxusers" "libvirtd" "networkmanager" "audio" ];
    home = "/home/dooy";
    createHome = true;
    initialPassword = "kali";
  };

  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  security.sudo.wheelNeedsPassword = false;

  nix.gc.automatic = true;
  nix.optimise.automatic = true;

  system.stateVersion = "20.09";

}


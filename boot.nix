{ configs, pkgs, ... }:

{
  boot = {
    initrd.supportedFilesystems = [ "zfs" ];
    supportedFilesystems = [ "zfs" ];
    zfs.enableUnstable = true;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernel.sysctl = {
      "vm.swappiness" = 0;
      "fs.inotify.max_user_watches" = 2048000;
    };

    cleanTmpDir = true;
   };

   services = {
     zfs.autoScrub = {
         enable = true;
         interval = "monthly";
         pools = [ ];
     };
     zfs.trim = {
         enable = true;
     };
   };

   console = {
     font = "ter-i32b";
     packages = with pkgs; [ terminus_font ];
     earlySetup = true;
   };

   i18n.defaultLocale = "en_US.UTF-8";

}

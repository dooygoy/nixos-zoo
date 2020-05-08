{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
   unetbootin
   leiningen openjdk11 cmake obs-studio    
   vscodium vscode
   wget vim emacs curl tmux kakoune kak-lsp
   sshfs bandwhich cookiecutter starship
   rclone zsh zsh-syntax-highlighting
   weechat watch up units tree tokei tig
   tcpdump strace sqlite rsync ripgrep ranger pwgen
   powertop powerstat pdftk paperkey pandoc
   nmap mpv moreutils lynx iw imagemagick htop
   gnupg ghostscript gettext fzf fpp findutils 
   dos2unix dnsutils direnv cpulimit cpufrequtils 
   cmatrix asciinema ascii whois git gitAndTools.hub
   gist awscli neofetch compton jq inkscape scrot
   qemu qemu_kvm mplayer bazel asciiquarium
   acpi arandr autorandr dunst feh i3 i3lock
   i3blocks kitty libnotify lxappearance 
   networkmanagerapplet parcellite pavucontrol
   redshift rofi unclutter dmenu maim pasystray 
   srandrd xautolock xdotool xfontsel xnee
   xorg.xbacklight xorg.xev xorg.xkill
   xlibs.xmodmap xbindkeys xscreensaver 
   slack zoom-us qutebrowser calibre pcmanfm 
   sbcl gnupg hdparm dhall nmap transmission-gtk
   vlc zathura firefox unzip unrar gparted
   cabal2nix cabal-install haskellPackages.stack
   ghc ripgrep fd clang coreutils ghcid
   stylish-haskell  
   blender hlint     
   flat-remix-icon-theme nordic gsettings-desktop-schemas
   
   figlet cowsay
   nix-prefetch-scripts patchelf nix-top niv
   nix-zsh-completions nixfmt
     
  ];

}

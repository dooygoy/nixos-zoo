# NixOS-zoo

This repo is a work in process, containing configuration files for my 
personal machine with NixOS unstable on encrypted zfs. But more, it will also contain 
educational NixOS/Nix* ecosystem recipes, documented workflows and notes in 
form of learning snippets. Hopefully this will evolve into *packaging* 
nixpkgs tutorials,interacting with Hydra/NixOps and playing 
with *nix* expression language.


## Contents

* [Preview](#preview)
* [TODO](#todo)
* [Default applications](#default-applications)
* [NixOS workflows](#nixos-workflows)

### Default applications:

- **OS**:            NixOS unstable
- **WM**:            i3-gaps with i3Blocks status line
- **Terminal**:      Kitty
- **Shell**:         Zsh
- **File explorer**: Ranger
- **Launcher**:      Rofi
- **Editor**:        Kanouke/Emacs
- **Browser**:       Qutebrowser
- **PDF viewer**:    Zathura


### Preview

![Screenshot](screenshot.png)

### TODO
 
- setup jack with Haskell Tidal
- 

### NixOS workflows

* Syncronizing nixos configuration files with git
  * [can I move /etc/nixos to my dotfiles and symlink it back to
/etc/nixos/?](https://discourse.nixos.org/t/can-i-move-etc-nixos-to-my-dotfiles-and-symlink-it-back-to-etc-nixos/4833/13)
> There's no need to symlink - `/etc/nixos/configuration.nix` is just the
default location, and you can change it. When you run nixos-rebuild, it looks up
the value of "nixos-config" in the NIX_PATH environment variable, so you can
point that wherever you want. Example (as root):
```
export NIX_PATH="nixos-config=/path/to/configuration.nix"
nixos-rebuild switch
```
Note: you could fetch your coniguration while still in  the installer and
install it all at once.

> Year your user can own `/etc/nixos/`. Rather than symlink or setup the
NIX_PATH, I just keep /etc/nixos directly as a git repo owned by my user. When
you boot up on the very first install, you can install git with nix-env, clone
the repo as root, build the OS, and then at a later point chown /etc/nixos to
yourself once your user exists.
  * Initializing a git repo:
```
# create a repository (example: nixos-zoo) on github.com without a README

cd dotfiles
echo "# nixos-zoo" >> README.md
git init
git add README.md
git commit -m "first commit"
git remote add origin https://github.com/username/nixos-zoo.git
```





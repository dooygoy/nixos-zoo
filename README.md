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
  * [Syncronizing NixOS With Git](#syncronizing-nixos-with-git)
  * [Documentation Request FHS](#documentation-request-fhs)
    * [FHS exploration continues](#fhs-exploration)
  * [How to package nix](#how-to-package-nix)
    * [Nix Pills](#nix-pills)
### Default applications:

- **OS**:            NixOS unstable
- **WM**:            i3-gaps with i3Blocks status line
- **Terminal**:      Kitty
- **Shell**:         Zsh
- **File explorer**: Ranger
- **Launcher**:      Rofi
- **Editor**:        Kakoune/Emacs
- **Browser**:       Qutebrowser
- **PDF viewer**:    Zathura


### Preview

![Screenshot](screenshot.png)

### TODO

- [ ] setup jack with Haskell Tidal
- [ ] nixpkgs!
- [ ] home-manager workflows

### NixOS workflows

### Syncronizing NixOS With Git

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

### Documentation Request FHS

Nix needs documentation for it's peculiar *FHS conventions*.
For example: the layout of `/run/current-system` or `/run/current-system/sw`,
how it relates to `XDG_DATA_DIRS`, etc. So also information explaining NixOS's
default `XDG` setting conventions? It might be good to also have *crosslinks* to
relevant module options.

Labels: 0.kind: bug, 6.topic: nixos, 9.needs: documentation

As always I first go to ArchWiki since I find the request a bit vague, need to
explore **FHS Conventions** in *general*.

> Arch Linux follows the *file system hierarchy* for operating systems using the
**systemd** service manager. See
[file-hierarchy](https://jlk.fjfi.cvut.cz/arch/manpages/man/file-hierarchy.7)
for an explanation of each directory along with their designations. In
particular, `/bin`, `/sbin`, and `/usr/sbin` are symbolic links to `/usr/bin`,
and `/lib` and `/lib64` are symbolic links to `/usr/lib`.

Note: But following the file-hierarchy link on `/run/` I read:

**RUNTIME DATA**

- `/run/` -> A "tmpfs" file system for system packages to place runtime data in. This
directory is flushed on boot, and generally writable for privileged programs
only. Always writeable.

- `/run/log/` -> Runtime system logs. System components may place private logs in
this directory. ALways writable, even when `/var/log/` might not be accessible
yet.

- `/run/user/` -> Contains per-user directories, each usually individually
mounted "tmpfs" instances. Always writable, flushed at each reboot and when the
user logs out. User code should not reference this directory directly, but via
the `$XDG_RUNTIME_DIR` environment variable, as documented in the **XDG Base
Directory Specification**.

```
> ls /run

agetty.reload   dhcpcd.sock          log             systemd     xtables.lock
binfmt          dhcpcd.unipriv.sock  mount           tmpfiles.z  zed.pid
blkid           initctl              NetworkManager  udev        zed.state
booted-system   keys                 nixos           udisks2
current-system  lightdm              nscd            user
dbus            lightdm.pid          opengl-driver   utmp
dhcpcd.pid      lock                 resolvconf      wrappers
```

Note: Now I am using `ranger` to explore the hierarchy since cd-ing and
i-ing into each directory is tedious. CLI file explorers such as ranger really
shine, I can see the whole structure and go back and forth. Ranger has nice
previews too so it can preview an image or a text file which greatly saves time.

I strolled around the root directory for a while observing various files but
then I begin to google term "nixos" and "fhs" and I see [Faking Non-NixOS for
Stack](https://vaibhavsagar.com/blog/2018/03/17/faking-non-nixos-stack/)
blogpost by Vaibhav Sagar. Vaibhav begins:
> I like most things about NixOS, but one thing I do not like is the way it
integrates with `stack`. Nix's own Haskell infrastructure works well enough that
this is not an issue for my own projects, but sometimes I want to test that the
Stack workflow is fine for people using less opinionated distros like Ubuntu.
Fortunately, **Nixpkgs includes a handy tool called** `buildFHSUserEnv` **which
will build a chroot wherein everything is laid out according to the [Filesystem
Hierarchy Standard](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)
that most software is accustomed to. This means we can provide an environment
with Stack and any dependencies and it will happily run.

* [ ] - read the blog post and build the **IHaskell** notebook!

Reading the wiki on FHS NixOS is mentioned too:
> Most Linux distributions follow the Filesystem Hierarchy Standard and declare
it their own policy to maintain FHS compliance. **GoboLinus** and **NixOS**
provide examples of intentionally non-compliant filesystem implementations. *But
it also says that:* The FHS is a 'trailing standard', and so documents common
practices at a point in time. Times of course change, and distribution goals and
needs call for experimentation. *And we come to our /run/ being mentioned too:*

Modern Linux distributions include a `/run` directory as a temporary filesystem
(tmpfs) which stores volatile runtime data, following the FHS version 3.0.
According to the FHS version 2.3, such data were stored in `/var/run` but this
was a problem in some cases because this directory is not always available at
early boot. As a result, these programs have had to resors to trickery, such as
using `/dev/.udev`..

Note: So it is rather flexible, distros are changing the overlay of the system,
and now I see some NixOS rants on how FHS is broken a bit with a smile since
they themselves are helping us be aware of that *brokeness* and by their work
and the work of others the FHS is actually changing, it just seems it takes a
long time for these changes to take action. I see Debian has moved a lot of
directories to `/run` in 2013.

Now I google more and find an interesting StackExchange answer [nixos
executable on NixOS](https://unix.stackexchange.com/questions/522822/different-methods-to-run-a-non-nixos-executable-on-nixos)
The user has explained several methods of running a script on nixos, the cool
part is that it is explained in three methods, the full manual, the patched
version and methods based on FHS plus some other advices. The user has included
a simple derivation as well and since I also would like learn nixpkgs packaging
this answer has lots of educational points! I am happy that by just exploring
seeminlgy boring issue such as FHS documentation I learned how to build IHaskell
notebooks with stack on NixOS and and also read about a process of packaging a
nix package from the essential manual method to a full derivation expression.

* [ ] - read the answer and study the packaging examples

The method 5 was to use FHS to simulate a classic linux shell, and manually
execute the files which is the same method used by Vaibhav in building IHaskell
on NixOS. User adds
> Some software may be hard to package that way because they may havily rely on
FHS file tree structure, or may check that the binary are unchanged. You can
then also use `buildFHSUserEnv` to provide an FHS file structure (lightweight,
using namespaces) for your application. **Note that this method is heavier that
the patch-based methods, and add significant startup time, so avoid it when
possible**

Our FHS NixOS adventure continues by reading this interesting post in NixOS
discourse on [Using Julia with
NixOS](https://discourse.julialang.org/t/using-julia-with-nixos/35129)
where again a nix *derivation* is described which *pulls* all the dependency libs and
sets up.
The user again mentions FHS issues with NixOS:
> To give an example of what it implies in the case of python, a typical
installation with `pip` or `conda` of a python package might not work, since it
is usually looking for files on specific dierctories (on a prescribed FHS like
`/usr/lib`, `/usr/share/` or similar) to serolve dependencies. Actually, it
happens that these dependencies are (or can be) in the system but not there
(when conda/pip are looking for them).

But the nice part is that the solution is simple when you look at the derivation
and the seemingly difficult problem is solved in an elegant nix way, again by
using just nix expression language.

### FHS exploration

Linux configuration:

- /etc
- /usr/share
- /opt
- $(HOME)
- $(XDG_CONFIG_HOME)
- $(XDG_CACHE_HOME)
- $(XDG_DATA_HOME)

You don't have that one singular place, it's usually
all over the system, and we haven't even looked inside these places.

- JSON?
- SQLite?
- Key/Value Pair?

I go to youtube and search for a nice video on XDG, who knows, maybe there are
some pretty visuals too? So I stumble upon Wolfgang's Channel, there are flashy retro lights and
the movie Hacker vibe. He talks about managing dotfiles and introduces GNU Stow,
which seems like an alternative to *Home-manager* the popular tool for managing
NixOS configurations. As far as I know Home-manager is capable to reproduce the
entire NixOS tree, not just user dotfile, I wonder if that is even possible with
GNU Stow?

> "The approach used by Stow is to install each package into its own tree, then
> use symbolic links to make it appear as though the files are installed in the
> common tree."

[Reading this interesting hacker news answer](https://news.ycombinator.com/item?id=11071754)
on managing dotfiles by initializing a git repo for the whole home.

```
git init --bare $HOME/.myconf
alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
config config status.showUntrackedFiles no

# where my ~/.myconf directory is a git bare repository. Then any file within the
home folder can be versioned with normal commands like:

config status
config add .vimrc
config commit -m "Add vimrc"
config add .config/redshift.conf
config commit -m "Add redshift config"
config push
```
But let's move on, I read a question on NixOS discourse [custom gsettings schema
being ignored in
xdg-data-dirs](https://discourse.nixos.org/t/custom-gsettings-schema-being-ignored-in-xdg-data-dirs/3449/2)
There is our little xdg friend again! Seems like a NixOS user **worldofpeace**
knows something about xdg issuse since he replies: "If you have any other issues
pacakaging cinnamon I could be a great assistance to you on the GTK side of
things. (available of freenode as worldofpeace and of course here)."
That is really nice, and I noticed too worldofpeace name of NixOS channel.
Worldofpeace seems like a very happy person too :) There is our person of
contact maybe.

I also see worldofpeace is working on
gnome documentation here: [doc: add GNOME #43150](https://github.com/NixOS/nixpk
gs/pull/43150). where a comment from **jtojnar** tells this should be enough:
```
xdg.icons.enable = true;
environment.systemPackages = [ pkgs.gnome3.adwaita-icon-theme ];
```
> I really need to write a chapter on creating a **baseline freedesktop system**
though, as many NixOS users run some kind of bare-bones WM.

cdepillabout adds:
> Yeah, this would be really nice. I run XMonad, but *not configured* from
`/etc/nixos/configuration.nix`. It would be great to have a guide as to how all
the freedesktop stuff is supposed to work in nix.

which brings me to my own NixOS setup. I did put the icon themes into the
separate `xserver.nix` file that is imported into `configuration.nix` but I am
also not really happy that I am setting up my theme by using `lxappearance`. I
am still do not know how to write the `theme-my-desktop.nix` where xdg, icons,
mouse, themes, gtk-engines etc. could be declared. They are merely in my
packages list, and no environment variables are defined. Also I am using i3wm
and yet I did try to setup XMonad since I am learning Haskell too
and failed several times. The NixOS wiki was not enough, at least not for me,
there were changes and the wiki has not been updated which brings us to
another task:

- [ ] Update NixOS wiki so that other users don't face the same problems you
face and plus, you learn by sharing your expressions too!

Following the gnome thread I see a wonderful rendered document by jtojnar on
packaging GNOME applications on NixOS at
https://jtojnar.github.io/dumpling/#sec-language-gnome

> Programs in the GNOME univrse are written in various languages but they all
use GOject-based libraires like GLib, GTK or GStreamer. These libraries are
often modular, relying on looking into certain directories to find their
modules. However, due to Nix's specific file system organization, this will fail
without our intervention. Fortunately, the libraries usually allow overriding
the directories through environment variables, either natively or thanks to a
patch in nixpkgs. Wrapping the executables to ensure correct paths are available
to the application constitutes a significant part of packaging a modern desktop
application. In this section, we will describe various modules needed by such
applications, environment variables needed to make the modules load, and finally
a script that will do the work for us.

But only after scrolling a bit up do I realize that this document is just one
part of the extensive [Nixpkgs Users and Contributors
Guide](https://nixos.org/nixpkgs/manual/)

Next I stumble upon this massive thread on NixOS on creating a [User-friendly
NixOS distro?](https://discourse.nixos.org/t/user-friendly-nixos-distro/1348/13)
and this is something I have been thinking about more and more. NixOS seems as
an excellent ground for creating Linux distributions since all configuration can
be declared as nix language expression. Something similar is
[arcolinux](www.arcolinux.info) which uses minimalistic Arch Linux as a ground
for various installable *configurations* of desktop environments and wm
environments. Some of them are XFCE, KDE, but also i3, bspwm, xmonad, qtile etc.
which are super interesting *productive oriented* setups with tiling managers
instead of our usual *bloated* DE's. Recently I showed the i3wm tiling manager
to some people and they love the automatic placement of windows, expecially the
cute i3-gaps fork which can make *gaps* between windows. Arco Linux has several
github repositories which contain necessary configuration files needed for a
*tinkerless* tiling manager experience while all the necessary freedesktop
configuration is configured with it as well. This is something what seems to be
missing in NixOS space and that is unfortunate because it would be wonderful if
we could for example just pick our configurations of preferred environments and
then just download the configs and just roll with our new wm.

Now, there are
several reproducible NixOS setups floating in github space but they still need
manual tinkering to properly set them up and I have myself failed several times
in setting them, so to say, they often do not really work out of the box, at
least not for non-experts. Maybe you will have more luck in setting them up. I
recommend the beautiful NixOS Xmonad setup at
https://github.com/karetsu/xmonad-aloysius and super pretty **starlight-os** at
https://github.com/isaacwhanson/starlight-os . These are all beautiful attempts
to bring this experience to end users, and a great ground for learning. I myself
have managed to setup my i3 using as a reference the
https://github.com/utdemir/dotfiles github repo after failing to just reproduce
the setup by following instructions. My whole pain points are described in
thi [github issue](https://github.com/utdemir/dotfiles/issues/29)
and utdemir was kind enough to thank and to offer some tips too. It all began
with my configuration not picking up my "workman" layout and then evolved into
several more issuse. These are all detailed in the same manner as these posts.

### How to package nix

Let's ask google how to package nix packages.
```
> www.google.com -> "how to package nix"
1. Packaging/Tutorial - NixOS Wiki
2. Nixpkgs/Create and debug packages - NixOS Wiki
```
Following the first link we see the quote
> The more you read, the faster you'll be able to build your package.
NOTE1: If you have time, read Nix Pills first.

Great so I have to read Nix Pills first.

### Nix Pills

Nix Pills provides a tutorial introduction into the Nix package manager and
Nixpkgs package collection, in the form of short chapters called 'pills' which
aim to complement the existing explanations from the more formal documents.

The basic problem with package managers is that they mutate the global state, or
seems to me some part of a state in order to bind together many dependencies
that are needed to build programs. These dependencies often have dependencies of
their own or many versions since programs are build incrementally so our target
program might collapse because dependencies cannot resolve their differences in
a *rational* manner. Each target program takes some space so how do you put next
to it the same program that has a different version number. Seems to me a single
program assumes the whole environment and is not smart enough to play along the
same version of itself in the same system. These programs seem very *static* and
*lifeless* in nature since they cannot resolve such issues. If I want to run two
different instances of some program I also have to make sure their libraries of
functions do not collide in our ecosystem. So what do we do? We chat them of
course, we set up *virtual* places, or containers that define the environment
the programs need to operate faithfully meaning we would need to set up two
different containers for two of our separate programs including all the
necessary libraries. Ok so now we have our ecosystem and two virtual containers
that are like an image of our own but with slightly different settings. Then we
can play with two programs as if they were peacefully next to each other. But
now we have an overlay of cruft because we have to somehow implement containers
and monitor what is happening on two different spaces. 
> Nix makes no assumptions about the global state of the system. In Nix there is
the notion of a *derivation* rather than a package.

Googling the notion of derivation we stumble upon an interesting wiki article on
[parse tree](https://en.wikipedia.org/wiki/Parse_tree)
> A **parse tree** or *parsing tree** or **derivation tree** or **concrete
syntax tree** is an ordered, rooted tree that represents the syntactic structure
of a string according to some context-free grammar. Parse trees are usually
constructed based on either the constituency relation of constituency grammars
or dependency relation of dependency grammars. 

Now this term [Dependency
grammar](https://en.wikipedia.org/wiki/Dependency_grammar) makes us think of
program dependencies and we see that these are theories that are based on the
*dependency relation* (as opposed to the *constituency relation* of phrase
structure).
> Dependency is the notion that linguistic units, e.g. words, are connected to
each other by directed links. The (finite) verb is taken to be the structural
center of clause structure. All other syntactic units (words) are eiether
directly or indirectly connected to the verb in terms of the directed links,
which are called **dependencies**.

Derivations/packages are stored in the Nix store as follows:
`/nix/store/hash-name` where the hash uniquely identifies the derivation.
so each program in the nix store is built by specific versions of its
dependencies and that is all defined in that hash. This actually means we could
have two versions of our programs which require different dependencies and they
will not collide since they have a *unique* name of their own, which is this
hash number we see in the nix store. Some programs do peek out and look for
global values so we need to *wrap* them up and setup the necessary environment,
so to say guide the program when it looks for things. This guiding needs to be
defined within our nix derivation when we first setup the program. So basically
there is no notion of upgrade/downgrade of programs in place. Each *upgrade* is
a new program in place with newly defined environment. 

Nix also has a database. It's stored under `/nix/var/nix/db` as a sqlite
database that keeps track of the dependencies between derivations. So Nix
expressions are used to describe packages and how to build them and Nixpkgs is
the repository containing all of the expressions. So basically the whole system
is defined with nix expressions which is kinda cool. If we ask
```nix
nix-store -q --references `which bash`
```
we get runtime dependencies and if we ask
```nix
nix-store -q --referrers `which bash`
```
we get reverse dependencies meaning the bash and the whole user environment that
depends on our bash. This roughly means our user environment is itself defined
with that specific version of bash. It is like we can inspect in both ways our
flow of dependencies seeing the ecosystem itself that is defined by specific
programs and seeing *runtime* specific dependencies that are needed for our bash
to run. 
```nix
nix-store -qR `which bash`
```
shows us a list of all dependencies but what is the difference between running
`-q --references` and `-qR`? `-qR` shows two more programs that are apparently
needed for a full reproducible environment on a different machine. This seems
like there are some systems related dependencies that also need to be synced if
we want our program to be *totally* reproducible.
```
nix-store -q --tree `which bash`
```
shows a pretty tree structure where we can see relations of dependencies.

Further, our list of programs in nix store is synced with nix packages that can
be updated through nix *channels*. Running `nix-channel --update` will run the
update same as `apt-get update` on ubuntu.

Some other commands:

```
ubuntu -> sudo apt-get install firefox

nixos -> add "firefox" to /etc/nixos/configuration.nix and run 
           sudo nixos-rebuild switch

# install a package for a specific user

ubuntu -> not possible

nixos -> add "firefox" to  users.users.username.packages = with pkgs; [firefox ];
in /etc/nixos/configuration.nix and run sudo nixos-rebuild switch

# install a service

ubuntu -> sudo apt install openssh-server
nixos -> add to /etc/nixos/configuration.nix
         services.openssh.enable = true;
```
See many more on [ubuntu/nixos commands](https://nixos.wiki/wiki/Cheatsheet)

Finally we get to the nix language! Launch nix repl!

```nix
> 1 + 1
2
> 6 / 3
2
```
If you do not put space between the operator and the operands nix might
understand division as a file path. Write `6/2` and see for yourself. Nix is
functional and lazy, similar to Haskell. In Haskell we would write:
`6 / 2` or `div 6 2` and in nix `6 / 2` or `builtins.div 6 3`. Strings are
`"strings"` or `''strings''`



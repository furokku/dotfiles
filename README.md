# dots
these are the dotfiles that i use on my system.<br>included are: xmonad, rofi, neofetch, i3-gaps, i3status, dunst, alacritty, picom, polybar, neovim etc. config files
<br>pretty much just a basic gruvbox + xmonad config

## xmonad
make sure you use xmonad 0.17, otherwise the config will not build because of the ewmhFullscreen option on line 266. remove that part in order to use on older versions (like 0.15)

### sidenote about xmonad
the way arch packages xmonad (and even the AUR) is odd and so every time you get updates for the haskell packages you'll have to rebuild the git versions of xmonad and xmonad-contrib (if you chose to install those in the first place)

## chaotic-aur
add the chaotic-aur repository to pacman in order to have some AUR packages already prebuilt for convenience

## dunst
~~dunst got a bunch of config options deprecated and whatnot so half the config doesn't work since i haven't been able to fully fix it yet~~
this has been fixed

## picom
picom got cut out from this config because of the issues it caused with window borders, however the file is still here if you want to use it

dont yell at me if they dont work<br>some things are defined as absolute paths so change those

some wallpapers also included


# install
`yay -S xorg-xrandr xmonad-git xmonad-contrib-git polybar mpc mpd mpv shotgun hacksaw numlockx xss-lock betterlockscreen rofi feh vimiv neovim alacritty pcmanfm-gtk3 lxappearance-gtk3 gedit pavucontrol font-terminus ttf-font-awesome ttf-ubuntu-font-family`

"why so many packages it's bloated" shut up

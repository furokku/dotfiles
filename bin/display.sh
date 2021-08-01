STATE="$(xrandr -q | grep HDMI-1-1 | cut -c 10,11,12)"
if [ $STATE = "con" ]
then
    xrandr --output HDMI-1-1 --primary --auto --output DP-1-1 --right-of HDMI-1-1 --auto --output eDP-1-1 --off;
    xrandr --dpi 96;
elif [ $STATE = "dis" ]
then
    xrandr --output eDP-1-1 --primary --auto --output HDMI-1-1 --off --output DP-1-1 --off;
    xrandr --dpi 96;
fi

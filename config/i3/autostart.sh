feh --bg-fill ~/Downloads/wall1.jpeg --no-xinerama &

autorandr --change --default small &
srandrd autorandr --change --default small &

sleep 1
unclutter &
nm-applet &
parcellite &
pasystray &
xautolock -locker "i3lock --color '#332233'"  -time 60 -detectsleep &
redshift -l -36.84853:174.76349 &

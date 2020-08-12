#/bin/sh

if [ $(cat /sys/class/power_supply/BAT1/status) = 'Discharging' ] && [ $(cat /sys/class/power_supply/BAT1/capacity) -lt 15 ]; then
    echo 'Low Battery' | osd_cat -p middle -A center -d 2 -f '-misc-fixed-medium-r-semicondensed--46-*-*-*-c' -o -110
fi

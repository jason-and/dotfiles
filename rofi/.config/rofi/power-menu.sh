#!/bin/bash

# Power menu for Hyprland using Rofi
options="Logout\nSuspend\nHibernate\nShutdown"

selected=$(echo -e $options | rofi -dmenu -i -p "Power Menu")

case $selected in
  Logout)
    uwsm exit
    ;;
  Suspend)
    systemctl suspend
    ;;
  Hibernate)
    systemctl suspend
    ;;
  Shutdown)
    systemctl shutdown -h now
    ;;
esac

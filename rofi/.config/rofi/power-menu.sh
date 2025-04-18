#!/bin/bash

# Power menu for Hyprland using Rofi
options="Logout\nSuspend\nHibernate\nShutdown"

selected=$(echo -e $options | rofi -dmenu -i -p "Power Menu")

case $selected in
  reboot)
    reboot
    ;;
  Logout)
    uwsm exit
    ;;
  Suspend)
    systemctl suspend
    ;;
  Hibernate)
    systemctl hibernate
    ;;
  Shutdown)
    systemctl shutdown -h now
    ;;
esac

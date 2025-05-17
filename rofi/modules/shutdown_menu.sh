#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/themes/shutdown_menu.rasi"

CHOICE=$(printf "Apagar\nReiniciar\nSuspender" | rofi -dmenu -p "" -theme "$ROFI_THEME")

case "$CHOICE" in
  "Apagar")
    systemctl poweroff
    ;;
  "Reiniciar")
    systemctl reboot
    ;;
  "Suspender")
    systemctl suspend
    ;;
esac
#!/bin/bash

bluetooth_state=$(bluetoothctl show | awk '/Powered/ {print $2}')

ROFI_THEME="$HOME/.config/rofi/themes/bluetooth_menu.rasi"

scan_devices() {
  notify-send "Bluetooth" "Escaneando dispositivos"
  bluetoothctl scan on & sleep 5
  bluetoothctl scan off

  DEVICES=$(bluetoothctl devices | cut -d ' ' -f3-)
  if [ -z "$DEVICES" ]; then
    notify-send "Bluetooth" "No se encontraron dispositivos"
    exit 1
  fi

  SELECTED=$(printf "$DEVICES" | rofi -dmenu -p "Dispositivos encontrados" -theme "$ROFI_THEME")
  if [ -n "$SELECTED" ]; then
    DEVICE_MAC=$(bluetoothctl devices | grep "$SELECTED" | awk '{print $2}')
    notify-send "Bluetooth" "Seleccionaste: $SELECTED ($DEVICE_MAC)"
    # Para conectar automáticamente:
    bluetoothctl connect "$DEVICE_MAC"
  fi
}

if [ "$bluetooth_state" = "yes" ]; then
    OPTIONS="Apagar Bluetooth\nEscanear dispositivos"
else
    OPTIONS="Encender Bluetooth"
fi

CHOICE=$(printf "$OPTIONS" | rofi -dmenu -p "" -theme "$ROFI_THEME")

case "$CHOICE" in
  "Apagar Bluetooth")
    rfkill block bluetooth
    ;;
  "Encender Bluetooth")
    rfkill unblock bluetooth
    ;;
  "Escanear dispositivos")
    scan_devices
    ;;
esac
#!/bin/bash

bluetooth_state=$(bluetoothctl show | awk '/Powered/ {print $2}')

ROFI_THEME="$HOME/.config/rofi/themes/bluetooth_menu.rasi"

scan_devices() {
  notify-send "Bluetooth" "Escaneando dispositivos"
  bluetoothctl scan on & sleep 2
  bluetoothctl scan off

  DEVICES=$(bluetoothctl devices | cut -d ' ' -f3-)
  if [ -z "$DEVICES" ]; then
    notify-send "Bluetooth" "No se encontraron dispositivos"
    exit 1
  fi

  DEVICES=$(echo "$DEVICES" | sed '/^\s*$/d')

  SELECTED=$(printf "$DEVICES" | rofi -dmenu -p "Dispositivos encontrados" -theme "$ROFI_THEME")
  if [ -n "$SELECTED" ]; then
    DEVICE_MAC=$(bluetoothctl devices | grep "$SELECTED" | awk '{print $2}')
    # Para conectar automáticamente:
    bluetoothctl connect "$DEVICE_MAC"
    notify-send "Bluetooth" "Conectado a: $SELECTED"
  fi
}

disconnect_device() {
  CONNECTED=$(bluetoothctl info | awk '/Device/ {mac=$2} /Connected: yes/ {print mac}')
  
  if [ -z "$CONNECTED" ]; then
    notify-send "Bluetooth" "No hay dispositivos conectados"
    return
  fi

  # Obtener nombres de dispositivos conectados
  CONNECTED_NAMES=$(bluetoothctl devices | grep "$CONNECTED" | cut -d ' ' -f3-)
  SELECTED=$(printf "$CONNECTED_NAMES" | rofi -dmenu -p "Desconectar" -theme "$ROFI_THEME")
  
  if [ -n "$SELECTED" ]; then
    DEVICE_MAC=$(bluetoothctl devices | grep "$SELECTED" | awk '{print $2}')
    bluetoothctl disconnect "$DEVICE_MAC"
    notify-send "Bluetooth" "Desconectado: $SELECTED"
  fi
}

connect_paired_device() {
  ALL_DEVICES=$(bluetoothctl devices)
  PAIRED_DEVICES=""

  while IFS= read -r line; do
    MAC=$(echo "$line" | awk '{print $2}')
    NAME=$(echo "$line" | cut -d ' ' -f3-)

    if bluetoothctl info "$MAC" | grep -q "Paired: yes"; then
      PAIRED_DEVICES+="$MAC|$NAME"$'\n'
    fi
  done <<< "$ALL_DEVICES"

  if [ -z "$PAIRED_DEVICES" ]; then
    notify-send "Bluetooth" "No hay dispositivos emparejados"
    return
  fi

  PAIRED_DEVICES=$(echo "$PAIRED_DEVICES" | sed '/^\s*$/d')

  SELECTED=$(echo "$PAIRED_DEVICES" | cut -d '|' -f2 | rofi -dmenu -p "Emparejados" -theme "$ROFI_THEME")

  if [ -n "$SELECTED" ]; then
    MAC=$(echo "$PAIRED_DEVICES" | grep "|$SELECTED" | cut -d '|' -f1)
    bluetoothctl connect "$MAC"
    notify-send "Bluetooth" "Conectado a: $SELECTED"
  fi
}

if [ "$bluetooth_state" = "yes" ]; then
    OPTIONS="Apagar Bluetooth\nEscanear dispositivos\nDispositivos emparejados\nDesconectar"
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
  "Desconectar")
    disconnect_device
    ;;
  "Dispositivos emparejados")
    connect_paired_device
    ;;
esac
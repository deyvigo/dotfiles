#!/bin/bash

# Verificar si Waybar está corriendo
if pgrep -x "waybar" > /dev/null
then
    # Si Waybar está corriendo, matarlo
    pkill waybar
else
    # Si Waybar no está corriendo, iniciarlo
    waybar &
fi
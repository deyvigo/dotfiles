#!/bin/bash

tmpfile="/tmp/zoomstatic.png"

# Captura de una región seleccionada
grim -g "$(slurp)" "$tmpfile"

# Mostrar imagen con zoom (por ejemplo, doble tamaño)
imv -f "$tmpfile" &

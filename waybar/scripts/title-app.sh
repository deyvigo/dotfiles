#!/bin/bash
app_name=$(hyprctl activewindow -j | grep '"class"' | sed -E 's/.*"class": "(.*)",/\1/')

app_name="${app_name//-/ }"

formatted_name=$(echo "$app_name" | awk '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) }}1')

echo "$formatted_name"
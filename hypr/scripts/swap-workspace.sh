#!/bin/bash

mkdir -p /tmp/hypr

monitors=/tmp/hypr/monitors_temp
hyprctl monitors > "$monitors"

if [[ -z $1 ]]; then
  echo "Error: se requiere el número de workspace como argumento."
  exit 1
else
  workspace=$1
fi

# Monitor con el foco del cursor
activemonitor=$(awk '
  $1 == "Monitor" { mon=$2 }
  $1 == "focused:" && $2 == "yes" { print mon; exit }
' "$monitors")

# Buscar el monitor que tiene activo el workspace solicitado
passivemonitor=$(awk -v ws="$workspace" '
  $1 == "Monitor" { mon=$2 }
  $1 == "active" && $2 == "workspace:" && $3 == ws { print mon; exit }
' "$monitors")

# Obtener el workspace activo en ese monitor
passivews=$(awk -v mon="$passivemonitor" '
  $1 == "Monitor" && $2 == mon { found=1; next }
  found && $1 == "active" && $2 == "workspace:" { print $3; exit }
' "$monitors")

# DEBUG
echo "==== DEBUG ===="
echo "Requested workspace: $workspace"
echo "Active monitor     : $activemonitor"
echo "Passive monitor    : $passivemonitor"
echo "Passive workspace  : $passivews"
echo "================="

# Si el workspace ya está activo en otro monitor, intercambia
if [[ "$workspace" == "$passivews" && "$activemonitor" != "$passivemonitor" && -n "$passivemonitor" ]]; then
  echo ">> Swapping $activemonitor <-> $passivemonitor"
  hyprctl dispatch swapactiveworkspaces "$activemonitor" "$passivemonitor"
else
  echo ">> Moving workspace $workspace to $activemonitor"
  hyprctl dispatch moveworkspacetomonitor "$workspace $activemonitor"
  hyprctl dispatch workspace "$workspace"
fi

exit 0

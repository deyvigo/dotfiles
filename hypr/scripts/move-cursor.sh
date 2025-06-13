#!/bin/bash

readarray -t monitors < <(hyprctl monitors | awk '/Monitor/ {print $2}' | sort)

# Obtener monitor activo
active=$(hyprctl monitors | awk '
  $1 == "Monitor" { mon=$2 }
  $1 == "focused:" && $2 == "yes" { print mon; exit }
')

echo "Active monitor: $active"

# Determinar siguiente monitor
for i in "${!monitors[@]}"; do
  if [[ "${monitors[$i]}" == "$active" ]]; then
    next_index=$(( (i + 1) % ${#monitors[@]} ))
    break
  fi
done

next_monitor="${monitors[$next_index]}"
echo "Next monitor: $next_monitor"

# Extraer geometría (posición y resolución) del siguiente monitor
geometry=$(hyprctl monitors | awk -v mon="$next_monitor" '
  $1 == "Monitor" && $2 == mon { found=1; next }
  found && $0 ~ /@.* at / {
    split($1, size, "x")
    split(size[2], dummy, "@")
    w = size[1]
    h = dummy[1]

    split($3, pos, "x")
    x = pos[1]
    y = pos[2]

    print x, y, w, h
    exit
  }
')

echo "Medidas: $geometry"

read x y w h <<< "$geometry"

center_x=$((x + w / 2))
center_y=$((y + h / 2))

echo "$x : $y"

hyprctl dispatch movecursor "$center_x" "$center_y"

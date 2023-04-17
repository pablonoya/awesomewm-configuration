#!/bin/bash

while true; do
  sleep 2
  WINDOWS=$(xdotool search --all --onlyvisible --desktop $(xprop -notype -root _NET_CURRENT_DESKTOP | cut -c 24-) "" 2>/dev/null)

  if [ -z "$WINDOWS" ]; then
    xdotool search --class mpv | xargs -I % xdotool key --window % p
  else
    xdotool search --class mpv | xargs -I % xdotool key --window % o
  fi
done

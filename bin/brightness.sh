#!/usr/bin/env bash
clear
## Original Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
##
## Modified By: @DefinitelyNotSimon13
## Applets : Brightness

# Import Current Theme
theme="$HOME/.config/rofi/config/applets.rasi"

# Brightness Info
backlights=($(brightnessctl -l | grep backlight | cut -d "'" -f 2))
backlightsStr=""
backlight=0
for b in "${backlights[@]}"; do
  brigthness=$(brightnessctl -d "$b" g)
  maxBrightness=$(brightnessctl -d "$b" m)
  brightness=$((brigthness * 100 / maxBrightness))
  backlight=$((backlight + brightness))
  backlightsStr+="$b, "
  echo $backlight
done
backlightsStr=${backlightsStr::-2}
backlight=$((backlight / ${#backlights[@]}))

if [[ $backlight -ge 0 ]] && [[ $backlight -le 29 ]]; then
    level="Low"
elif [[ $backlight -ge 30 ]] && [[ $backlight -le 49 ]]; then
    level="Optimal"
elif [[ $backlight -ge 50 ]] && [[ $backlight -le 69 ]]; then
    level="High"
elif [[ $backlight -ge 70 ]] && [[ $backlight -le 100 ]]; then
    level="Peak"
fi

# Theme Elements
prompt="${backlight}%"
mesg="Device(s): ${backlightsStr} | Level: $level"

list_col='3'
list_row='1'
win_width='550px'

# Options
option_1="󰖜"
option_2=""
option_3="󰖛"

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "window {width: $win_width;}" \
        -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme "${theme}"
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$option_1\n$option_2\n$option_3" | rofi_cmd
}

# Execute Command
run_cmd() {
    if [[ "$1" == '--opt1' ]]; then
      for b in "${backlights[@]}"; do
        brightnessctl -d "$b" s 5%+
      done
    elif [[ "$1" == '--opt2' ]]; then
      for b in "${backlights[@]}"; do
        brightnessctl -d "$b" s 50%
      done
    elif [[ "$1" == '--opt3' ]]; then
      for b in "${backlights[@]}"; do
        brightnessctl -d "$b" s 5%-
      done
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
"$option_1")
    run_cmd --opt1
    ;;
"$option_2")
    run_cmd --opt2
    ;;
"$option_3")
    run_cmd --opt3
    ;;
esac

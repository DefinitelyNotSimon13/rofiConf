#!/usr/bin/env bash

## Original Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
##
## Modified By: @DefinitelyNotSimon13
## Applets : Screenshot

# Import Current Theme
theme="$HOME/.config/rofi/config/applets.rasi"

# Theme Elements
prompt='Screenshot'
mesg="Screenshots will be saved to: \"$HOME/Pictures/Screenshots\""

list_col='4'
list_row='1'
win_width='670px'

# Options
option_1="󰍹"
option_2="󰆞"
option_3="󰖉"
option_4=""

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "window {width: $win_width;}" \
        -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme "${theme}"
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$option_1\n$option_2\n$option_3\n$option_4" | rofi_cmd
}

# Screenshot
time=$(date +%Y-%m-%d-%H-%M-%S)
geometry=$(xrandr | grep 'current' | head -n1 | cut -d',' -f2 | tr -d '[:blank:],current')
dir="$HOME/Pictures/Screenshots"
file="Screenshot_${time}_${geometry}.png"

if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
fi

# notify and view screenshot
notify_view() {
    notify_cmd_shot='dunstify -u low --replace=699'
    viewnior "${dir}"/"$file"
    if [[ -e "$dir/$file" ]]; then
        ${notify_cmd_shot} "Screenshot Saved."
    else
        ${notify_cmd_shot} "Screenshot Deleted."
    fi
}

# countdown
countdown() {
    for sec in $(seq "$1" -1 1); do
        dunstify -t 1000 --replace=699 "Taking shot in : $sec"
        sleep 1
    done
}

# take shots
shotnow() {
    cd "${dir}" && sleep 0.5 && grim "$file"
    notify_view
}

shot5() {
    countdown '5'
    sleep 1 && cd "${dir}" && grim "$file"
    notify_view
}

shot10() {
    countdown '10'
    sleep 1 && cd "${dir}" && grim "$file"
    notify_view
}

shotarea() {
    cd "${dir}" && grim -g "$(slurp)" "$file"
    notify_view
}

# Execute Command
run_cmd() {
    if [[ "$1" == '--opt1' ]]; then
        shotnow
    elif [[ "$1" == '--opt2' ]]; then
        shotarea
    elif [[ "$1" == '--opt3' ]]; then
        shot5
    elif [[ "$1" == '--opt4' ]]; then
        shot10
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
"$option_4")
    run_cmd --opt4
    ;;
esac

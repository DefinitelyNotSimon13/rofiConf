#!/usr/bin/env bash

## Original Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
##
## Modified By: @DefinitelyNotSimon13
## Applets : MPD (music)

# Import Current Theme
theme="$HOME/.config/rofi/config/applets.rasi"

# Theme Elements
status=$(playerctl status)
if [[ -z "$status" || "$status" == "No players found" ]]; then
    prompt='Offline'
    mesg="MPD is Offline"
else
    prompt=$(playerctl metadata artist)
    mesg="$(playerctl metadata title) | \
$(playerctl metadata --format '{{ duration(position )}}/{{ duration(mpris:length) }}')"
fi

list_col='6'
list_row='1'

if [[ ${status} == "Playing" ]]; then
    option_1=""
else
    option_1=""
fi
option_2=""
option_3=""
option_4=""
option_5=""
option_6=""

# Toggle Actions
active=''
urgent=''
# Repeat
if [[ $(playerctl shuffle) == "On" ]]; then
    active="-a 4"
elif [[ $(playerctl shuffle) == "Off" ]]; then
    urgent="-u 4"
else
    option_5=" Parsing Error"
fi

# Random
if [[ $(playerctl loop) == "Playlist" ]]; then
    [ -n "$active" ] && active+=",5" || active="-a 5"
elif [[ $(playerctl loop) == "Track" ]]; then
    [ -n "$active" ] && active+=",5" || active="-a 5"
elif [[ $(playerctl loop) == "None" ]]; then
    [ -n "$urgent" ] && urgent+=",5" || urgent="-u 5"
else
    option_6=" Parsing Error"
fi

# Player
player=$(playerctl metadata --format '{{playerName}}')
if [[ ${player} == "spotify" ]]; then
    playerIcon=""
else
    playerIcon=""
fi

themeString='textbox-prompt-colon {str: "'$playerIcon'";}'
# Rofi CMD
rofi_cmd() {
    rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str "$themeString" \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        "${active}" "${urgent}" \
        -markup-rows \
        -theme "${theme}"
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
}

currentlyPlaying() {
    echo "$(playerctl metadata title) | \
$(playerctl metadata --format '{{ duration(position )}}/{{ duration(mpris:length) }}')"
}

# Execute Command
run_cmd() {
    if [[ "$1" == '--opt1' ]]; then
        playerctl play-pause && notify-send -u low -t 1000 " $(playerctl metadata artist)" \
            "$(currentlyPlaying)"
    elif [[ "$1" == '--opt2' ]]; then
        playerctl stop
    elif [[ "$1" == '--opt3' ]]; then
        playerctl previous && notify-send -u low -t 1000 " $(playerctl metadata artist)" \
            "$(currentlyPlaying)"
    elif [[ "$1" == '--opt4' ]]; then
        playerctl next && notify-send -u low -t 1000 " $(playerctl metadata artist)" \
            "$(currentlyPlaying)"
    elif [[ "$1" == '--opt5' ]]; then
        loopStatus="$(playerctl loop)"
        if [[ "$loopStatus" == "None" ]]; then
            playerctl loop playlist
        elif [[ "$loopStatus" == "Playlist" ]]; then
            playerctl loop track
        elif [[ "$loopStatus" == "Track" ]]; then
            playerctl loop none
        fi
    elif [[ "$1" == '--opt6' ]]; then
        playerctl shuffle toggle
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
"$option_5")
    run_cmd --opt5
    ;;
"$option_6")
    run_cmd --opt6
    ;;
esac

#!/usr/bin/env bash

## Original Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
##
## Modified By: @DefinitelyNotSimon13
## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)
dir="$HOME/.config/rofi/config"
theme='launcher'

## Run
rofi \
    -show drun \
    -theme "${dir}/${theme}.rasi" \
    - monitor 1 \

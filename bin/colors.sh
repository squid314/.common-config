#!/bin/bash

for effect in {0..9} ; do
    for _bg in {40..49} ; do
        for _fg in {30..39} ; do
            printf "\e[$effect;$_bg;${_fg}m"" $effect;$_bg;$_fg""\e[0m"
        done
        echo
    done
    echo
done

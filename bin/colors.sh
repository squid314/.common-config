#!/bin/bash

for effect in {0..9} ; do
    for _bg in {40..49} ; do
        for _fg in {30..39} ; do
            printf '\e[%s;%s;%sm %s;%s;%s\e[0m' $effect $_bg $_fg $effect $_bg $_fg
        done
        echo
    done
    echo
done

echo 'Fonts?:'
for font in {10..19} ; do
    printf '\e[%smABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz\e[0m\n' $font
done

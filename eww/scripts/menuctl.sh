#!/bin/bash

if [[ -z $(eww active-windows | grep 'menuctl') ]]; then
    /usr/bin/eww open menuctl
    /usr/bin/eww update menurev=true
else
    /usr/bin/eww update menurev=false
    /usr/bin/eww close menuctl
fi
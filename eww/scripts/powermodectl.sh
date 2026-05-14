#!/bin/bash

# Toggle power mode dropdown
if [ "$(eww get powermode_open)" = "true" ]; then
    eww update powermode_open=false
    eww close powermode_dd
else
    eww update powermode_open=true
    eww open powermode_dd
fi
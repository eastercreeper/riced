#!/bin/bash

mode=$(fcitx5-remote -n | tr '[:upper:]' '[:lower:]')

if [[ "$mode" == *"mozc"* || "$mode" == *"japanese"* || "$mode" == *"jp"* ]]; then
  echo "JP"
else
  echo "EN"
fi
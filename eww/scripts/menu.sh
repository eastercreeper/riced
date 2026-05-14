#!/bin/bash

names=(
  "Firefox"
  "OSU!"
  "Moonlight"
  "Discord"
  "Sublime"
  "Komikku"
  "Soundcloud"
  "Heroic"
)

execs=(
  "firefox"
  "flatpak run sh.ppy.osu"
  "flatpak run com.moonlight_stream.Moonlight"
  "/usr/bin/discord"
  "subl"
  "komikku"
  "cd /home/kairii/BetterSoundCloud && ./start.sh"
  "flatpak run com.heroicgameslauncher.hgl"
)

icons=(
  "/usr/share/icons/hicolor/128x128/apps/firefox.png"
  "/home/kairii/Documents/LOGO/osu!.png"
  "/var/lib/flatpak/app/com.moonlight_stream.Moonlight/x86_64/stable/abab1d8cf9251edbe32adab6fd6c04a9427b74732663f9a5c8e3b68012a32c19/files/share/app-info/icons/flatpak/128x128@2/com.moonlight_stream.Moonlight.png"
  "/usr/share/icons/hicolor/256x256/apps/discord.png"
  "/usr/share/icons/hicolor/256x256/apps/sublime-text.png"
  "/usr/share/icons/hicolor/scalable/apps/info.febvre.Komikku.svg"
  "/home/kairii/BetterSoundCloud/app/lib/assets/sc-icon.jpg"
  "/var/lib/flatpak/app/com.heroicgameslauncher.hgl/x86_64/stable/1df7e207217c5b5a18e5e0fbd33f3da44800df548f3fe7667784fb36e683b6ac/files/bin/heroic/usr/share/icons/hicolor/256x256/apps/heroic.png"
)

# Must have the same number of entries as names/execs/icons
terminal=(
  false
  false  # Firefox
  false  # Moonlight (GUI)
  false  # Discord
  false   # Text Editor (nvim is terminal-based; set false only if you use a GUI client like neovide)
  false  # Komikku (GUI)
  false  # Soundcloud
  false  # Heroic (GUI)
)

json="["

for i in "${!names[@]}"; do
  [[ $i -ne 0 ]] && json+=","
  json+="{\"name\":\"${names[$i]}\",\"exec\":\"${execs[$i]}\",\"icon\":\"${icons[$i]}\",\"terminal\":${terminal[$i]}}"
done

json+="]"
echo "$json"

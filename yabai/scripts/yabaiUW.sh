# ~/.config/yabai/scripts/yabai-ultra.sh

windows=$(yabai -m query --windows --display 1 | jq '[.[] | select(."is-visible"==true and ."is-floating"==false)] | length')

if [[ $windows == 1 ]]; then
  yabai -m config split_type vertical
  yabai -m space --padding abs:10:10:100:100
elif [[ $windows == 2 ]]; then
  yabai -m config split_type auto
  yabai -m space --padding abs:10:10:100:100

elif [[ $windows > 2 ]]; then
  yabai -m config split_type auto
  yabai -m space --padding abs:10:10:35:35
fi
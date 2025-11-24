set -e

choices=("1) Hyprland Config" "2) Waybar" "3) All" "4) Recover from backup" "5) Delete Backup Dir")

echo "What do you want to install ?"

for choice in "${choices[@]}"; do
    echo "$choice"
done

read -r u_choice
while [[ "$u_choice" != "1" && "$u_choice" != "2" && "$u_choice" != "3" && "$u_choice" != "4" && "$u_choice" != "5" ]]; do
  echo "Please choose 1, 2 or 3."
  read -r u_choice
done

if [ $u_choice == 1 ]; then
    configs=(hypr)
fi

if [ $u_choice == 2 ]; then
    configs=(waybar)
fi

if [ $u_choice == 3 ]; then
    configs=(hypr waybar)
fi

last_backup="ls -td ./.backup/*/ | head -n 1"

if [ $u_choice == 4 ]; then
    rm -rf $HOME/.config/hypr
    rm -rf $HOME/.config/waybar 
    mv `ls -td $HOME/.backup* | head -1`/** $HOME/.config/
    rm -rf `ls -td $HOME/.backup* | head -1`
    echo "Replace by backup dir"
    exit 0
fi

if [ $u_choice == 5 ]; then
    rm -rf $HOME/.backup_config**
    echo "All Backup Dir has been deleted."
    exit 1
fi

if [[ $u_choice == 1 || $u_choice == 3 ]]; then
    command -v hyprctl >/dev/null || { 
        echo "hyprland isn't install on this desktop.";
        exit 1
    }
fi

if [[ $u_choice == 2 || $u_choice == 3 ]]; then
    command -v waybar >/dev/null || {
        echo "waybar isn't install on this desktop 'pacman -S waybar'";
        exit 1
    }
fi

backup_dir="$HOME/.backup_config_$(date +%s)"

if [[ -d "$HOME/.config/hypr" && ( $u_choice == 1 || $u_choice == 3 ) ]]; then
    mkdir -p "$backup_dir"
    echo "Add a backup dir with hypr."
    mv "$HOME/.config/hypr" "$backup_dir"
fi

if [[ -d "$HOME/.config/waybar" && ( $u_choice == 2 || $u_choice == 3 ) ]]; then
    mkdir -p "$backup_dir"
    echo "Add a backup dir with waybar."
    mv "$HOME/.config/waybar" "$backup_dir"
fi

for cfg in "${configs[@]}"; do
    mkdir -p "$HOME/.config/$cfg"
    cp -r "$(dirname "$0")/src/$cfg"/* "$HOME/.config/$cfg/" || {
        echo "Error appear during the copy." ;
        exit 1
    }
done

echo "Copy done !"
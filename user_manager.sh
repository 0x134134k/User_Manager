#!/bin/bash
clear
text="\e[1m                  AdBud User Manager                   \e[0m"
color="\e[44m"
width=$(tput cols)
padding=$(( ($width - ${#text})))
#tput cup 2 $padding
echo -ne "${color}${text}\033[0m\n"

echo "   User Manager Menu!"

while  true;do
# Display menu and prompt user for selection
select option in "Change root password" "Switch to root" "Add new user" "Delete user" "Delete this script" "Exit"; do
  case $option in
    "Change root password")
      # Prompt user for new root password
      read -sp "Enter new root password: " root_password
      echo

      # Change root password
      sudo passwd -u root <<< "$root_password"
      break
      ;;
    "Switch to root")
      # Switch to root user
      su
      break
      ;;
    "Add new user")
      # Prompt user for new username and password
      read -p "Enter username: " username
      read -sp "Enter password: " password
      echo

      # Add new user
      sudo useradd -m -s /bin/bash $username
      echo "$username:$password" | sudo chpasswd
      break
      ;;
    "Delete user")
      # Prompt user for username to delete
      read -p "Enter username to delete: " username

      # Delete user
      sudo userdel -r $username
      break
      ;;
    "Delete this script")
      # Delete this script
      rm $0
      echo "Script deleted."
      break
      ;;
    "Exit")
      # Exit script
      exit;;
    *) echo "Invalid option";;
  esac
done
done

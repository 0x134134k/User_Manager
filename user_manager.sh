#!/bin/bash
clear
text="\e[1m                  AdBud User Manager                   \e[0m"
color="\e[44m"
width=$(tput cols)
padding=$(( ($width - ${#text})))
#tput cup 2 $padding
echo -ne "${color}${text}\033[0m\n"

echo "   User Manager Menu!"

while true; do
  # Display menu and prompt user for selection
  select option in "Change root password\n" "Switch to root" "Add new user" "Delete user" "Edit SSH config" "Restart SSH service" "Delete this script" "Exit"; do
    case $option in
      "Change root password")
        # Prompt user for new root password
        read -sp "Enter new root password: " root_password
        echo

        # Change root password
        echo -e "$root_password\n$root_password" | sudo passwd root
        break
        ;;
      "Switch to root")
        # Prompt user for root password and switch to root if correct
        read -sp "Enter root password: " root_password
        echo

        # Switch to root if password is correct
        if sudo -kS whoami <<< "$root_password" && sudo -n true; then
          sudo su -
        else
          echo "Incorrect password"
        fi
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
      "Edit SSH config")
        # Check if SSH config has been edited already
        # Check if SSH config has been edited already
if sudo grep -Eq "^#?PasswordAuthentication\s+(no|yes)$" /etc/ssh/sshd_config; then
  # SSH config has been edited, replace with "PasswordAuthentication yes"
  sudo sed -i -E 's/^#?PasswordAuthentication\s+(no|yes)$/PasswordAuthentication yes/' /etc/ssh/sshd_config

        else
          # SSH config has not been edited, add a comment
          sudo sed -i '1i# Password authentication has been disabled' /etc/ssh/sshd_config
        fi
        echo "SSH config updated."
        break
        ;;
      "Restart SSH service")
        # Restart SSH service
        sudo service ssh restart
        echo "SSH service restarted."
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


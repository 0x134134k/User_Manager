#!/bin/bash
clear
text="\e[1m                  AdBud User Manager                   \e[0m"
color="\e[44m"
width=$(tput cols)
padding=$(( ($width - ${#text})))
#tput cup 2 $padding
echo -ne "${color}${text}\033[0m\n"

while true; do
  # Display menu and prompt user for selection
  echo "User Manager Menu!"
  echo "1. Change root password"
  echo "2. Switch to root"
  echo "3. Add new user"
  echo "4. Delete user"
  echo "5. Edit SSH config"
  echo "6. Restart SSH service"
  echo "7. Delete this script"
  echo "8. Exit"

  read -p "Select an option: " option
  case $option in
    1)
      # Prompt user for new root password
      read -sp "Enter new root password: " root_password
      echo

      # Change root password
      echo -e "$root_password\n$root_password" | sudo passwd root
      ;;
    2)
      # Prompt user for root password and switch to root if correct
      read -sp "Enter root password: " root_password
      echo

      # Switch to root if password is correct
      if sudo -kS whoami <<< "$root_password" && sudo -n true; then
        sudo su -
      else
        echo "Incorrect password"
      fi
      ;;
    3)
      # Prompt user for new username and password
      read -p "Enter username: " username
      read -sp "Enter password: " password
      echo

      # Add new user
      sudo useradd -m -s /bin/bash $username
      echo "$username:$password" | sudo chpasswd
      ;;
    4)
      # Prompt user for username to delete
      read -p "Enter username to delete: " username

      # Delete user
      sudo userdel -r $username
      ;;
    5)
      # Check if SSH config has been edited already
      if sudo grep -Eq "^#?PasswordAuthentication\s+(no|yes)$" /etc/ssh/sshd_config; then
        # SSH config has been edited, replace with "PasswordAuthentication yes"
        sudo sed -i -E 's/^#?PasswordAuthentication\s+(no|yes)$/PasswordAuthentication yes/' /etc/ssh/sshd_config
      else
        # SSH config has not been edited, add a comment
        sudo sed -i '1i# Password authentication has been disabled' /etc/ssh/sshd_config
      fi
      echo "SSH config updated."
      ;;
    6)
      # Restart SSH service
      sudo service ssh restart
      echo "SSH service restarted."
      ;;
    7)
      # Delete this script
      rm $0
      echo "Script deleted."
      ;;
    8)
      # Exit script
      exit;;
    *)
      echo "Invalid option";;
  esac
done

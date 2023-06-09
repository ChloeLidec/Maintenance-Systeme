#!/bin/bash

# Reset
COLOR_OFF='\033[0m'       # Text Reset

# Regular Colors
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green
YELLOW='\033[0;33m'       # Yellow
BLUE='\033[0;34m'         # Blue

eval SELECTION=( $(whiptail --title "Electron" --checklist \
"Choose what you want to install" 25 80 8 \
"Node.js" "" ON \
"NPM" "" ON \
"Electron" "" ON \
"Npm intellisense" "" OFF \
"ESLint" "" OFF 3>&1 1>&2 2>&3))

if [ "${#SELECTION[@]}" != 0 ]; then
    for choice in "${SELECTION[@]}"; do
        if [ "$choice" == "Node.js" ]; then
            sudo apt-get install -y nodejs
            echo -e "${GREEN} Node.js installation done ${COLOR_OFF}"
        elif [ "$choice" == "NPM" ]; then
            sudo apt install -y npm
            echo -e "${GREEN} NPM installation done ${COLOR_OFF}"
        elif [ "$choice" == "Install Electron" ]; then
            if [ ! -x "$(command -v npm)" ]; then
                echo -e "${YELLOW} npm is going to be installed to proceed. ${COLOR_OFF}"
                sudo apt install -y npm
            fi
            sudo npm i electron -g
            echo -e "${GREEN} Electron installation done ${COLOR_OFF}"
        elif [ "$choice" == "Npm intellisense" ]; then
            if [ ! -x "$(command -v code)" ]; then
                echo -e "${YELLOW} Visual Studio Code is going to be installed to proceed. ${COLOR_OFF}"
                sudo snap install code --classic
            fi
            code --install-extension christian-kohler.npm-intellisense
            echo -e "${GREEN} Npm intellisense installation done ${COLOR_OFF}"
        elif [ "$choice" == "ESLint" ]; then
            if [ ! -x "$(command -v code)" ]; then
                echo -e "${YELLOW} Visual Studio Code is going to be installed to proceed. ${COLOR_OFF}"
                sudo snap install code --classic
            fi
            code --install-extension dbaeumer.vscode-eslint
            echo -e "${GREEN} ESLint installation done ${COLOR_OFF}"
        fi
    done
    echo -e "${GREEN} Installation complete ${COLOR_OFF}"
else
    echo -e " ${RED} User selected Cancel. ${COLOR_OFF}"
fi

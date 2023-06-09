#!/bin/bash

# Reset
COLOR_OFF='\033[0m'       # Text Reset

# Regular Colors
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green
YELLOW='\033[0;33m'       # Yellow
BLUE='\033[0;34m'         # Blue

CHOIX=$(whiptail --title "Java" --menu \
"Choose what you want to do" 25 80 8 \
"See java installations" "" \
"Export project as jar" "" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    if [ "$CHOIX" == "See java installations" ]; then
        eval SELECTED=( $(whiptail --title "Java" \
        --checklist "Choose what you want to install" 25 80 8 \
        "Java" "" ON \
        "MariaDB jdbc" "" OFF \
        "Java vscode extensions" "" OFF \
        "Maven" "" OFF 3>&1 1>&2 2>&3))

        if [ "${#SELECTED[@]}" != 0 ]; then
            for choice in "${SELECTED[@]}"; do
                if [ "$choice" == "Java" ]; then
                    sudo apt install -y default-jre
                    sudo apt install -y default-jdk
                    echo -e "${GREEN} Java installation done ${COLOR_OFF}"
                elif [ "$choice" == "MariaDB jdbc" ]; then
                    sudo apt install -y libmariadb-java
                    echo -e "${GREEN} MariaDB jdbc instalaltion done ${COLOR_OFF}"
                elif [ "$choice" == "Java vscode extensions" ]; then
                    if [ ! -x "$(command -v code)" ]; then
                        echo -e "${YELLOW} Visual Studio Code is going to be installed to proceed. ${COLOR_OFF}"
                        sudo snap install code --classic
                    fi
                    code --install-extension visualstudioexptteam.vscodeintellicode 
                    code --install-extension vscjava.vscode-java-debug 
                    code --install-extension redhat.java 
                    code --install-extension vscjava.vscode-maven 
                    code --install-extension vscjava.vscode-java-test 
                    code --install-extension vscjava.vscode-java-dependency
                    echo -e "${GREEN} Java vscode extensions installation done ${COLOR_OFF}"
                    echo -e "${YELLOW} If there was an installation error, it is probably because you don't have code installed. ${COLOR_OFF}"
                    echo -e "${BLUE} You can install code by running the principal script ${COLOR_OFF}"
                elif [ "$choice" == "Maven" ]; then
                    sudo apt install -y maven
                    echo -e "${GREEN} Maven installation done ${COLOR_OFF}"
                fi
            done
            echo -e "${GREEN} Installation complete ${COLOR_OFF}"
        else
            echo -e " ${RED} User selected Cancel. ${COLOR_OFF}"
        fi
    elif [ "$CHOIX" == "Export project as jar" ]; then
        if (whiptail --title "Info export" --yesno "Does your project use other things than java such as jdbc or javafx?" 8 78); then
            echo -e "${YELLOW} You need to use maven and configure the project with vscode to export your project correctly ${COLOR_OFF}"
        else
            echo -e " ${BLUE} What do you want to name your jar file? (with .jar at the end) ${COLOR_OFF}"
            read JAR_NAME
            echo -e "${BLUE} What is the path(absolute) to your project? ${COLOR_OFF}"
            read PROJECT_PATH
            jar cvfe $JAR_NAME Main $PROJECT_PATH
        fi
    fi
else
    echo -e "${RED} You chose Cancel. ${COLOR_OFF}"
fi
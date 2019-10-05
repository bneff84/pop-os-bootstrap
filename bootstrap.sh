#!/bin/bash

#get the current directory of the script
BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"

#prompt user for sudo as we're going to need it
sudo echo "
                                                   ///////////////
                                             */////////////////////////*
                                          /////////////////////////////////
                                       ///////////////////////////////////////
                                     /////////,           //////////////////////
                                   ////////*                */////////////////////
                                  ///////                     /////////////////////
                                .///////         ////         ./////////////////////.
                               *////////*        /////.        //////////////////////,
                               //////////*        /////        /////.     ////////////
                              ////////////*        ////*       ////.        ///////////
                             //////////////*        ///       /////        *////////////
                             ///////////////*                //////        /////////////
                             /////////////////             ////////       //////////////
                             //////////////////         ,/////////.      ///////////////
                             ///////////////////       *//////////     .////////////////
                             ////////////////////       //////////    //////////////////
                             /////////////////////       /////////   ///////////////////
                             //////////////////////       //////////////////////////////
                              //////////////////////      ////////,////////////////////
                               //////////////////////,     /////    //////////////////
                               *///////////////////////   //////,   /////////////////,
                                ,///////////////////////////////////////////////////,
                                  /////////                               /////////
                                   ////////                               ////////
                                     ///////*,,,,,,,,,,,,,,,,,,,,,,,,,,,*///////
                                       ///////////////////////////////////////
                                          /////////////////////////////////
                                             */////////////////////////*

       ____                ___  ____  _   _  ___   ___  _  _     ____              _       _
      |  _ \ ___  _ __    / _ \/ ___|| | / |/ _ \ / _ \| || |   | __ )  ___   ___ | |_ ___| |_ _ __ __ _ _ __
      | |_) / _ \| '_ \  | | | \___ \| | | | (_) | | | | || |_  |  _ \ / _ \ / _ \| __/ __| __| '__/ _\` | '_ \\
      |  __/ (_) | |_) | | |_| |___) |_| | |\__, | |_| |__   _| | |_) | (_) | (_) | |_\__ \ |_| | | (_| | |_) |
      |_|   \___/| .__/___\___/|____/(_) |_|  /_(_)___/   |_|   |____/ \___/ \___/ \__|___/\__|_|  \__,_| .__/
                 |_| |_____|                                                                            |_|

This is NOT an un-attended installation script. The majority of the installation can continue without your
input, but there may be action needed by you to confirm sudo access along the way. With a good internet connection
this process should only take a few minutes to complete. Please sit tight. Your patience will be rewarded!"
read -p "Press [enter] to continue or ctrl-c to exit"

#add the lid state switch to kernelstub so we don't get stuck in a suspend loop after closing/opening the laptop lid
sudo kernelstub -a button.lid_init_state=open

#add custom repo for older versions of php
sudo add-apt-repository ppa:ondrej/php -y

# remove preinstalled stuff we don't need (aka apache) and cleanup any unused packages
sudo apt -y remove apache2
sudo apt -y autoremove

#run an update of repos and upgrade any existing software with available upgrades before continuing
sudo apt update
sudo apt -y upgrade

#install all required software
#install mysql server, git, composer, dbeaver (DB GUI) and dependencies for valet-linux
sudo apt -y install git jq xsel libnss3-tools composer mysql-server dbeaver-ce
#install php 7.3
sudo apt -y install php7.3 php7.3-fpm php7.3-cli php7.3-common php7.3-curl php7.3-gd php7.3-bcmath php7.3-xml php7.3-mbstring php7.3-xml php7.3-xmlrpc php7.3-mysql php7.3-soap php7.3-intl php7.3-ldap php7.3-curl
#php 7.2 causes errors in valet-linux at the time of the creating of this tool, hence it not being included -- install at your own risk
#sudo apt -y install php7.2 php7.2-fpm php7.2-cli php7.2-common php7.2-curl php7.2-gd php7.2-bcmath php7.2-xml php7.2-mbstring php7.2-xml php7.2-xmlrpc php7.2-mysql php7.2-soap php7.2-intl php7.2-ldap php7.2-curl
#install php 7.1
sudo apt -y install php7.1 php7.1-fpm php7.1-cli php7.1-common php7.1-curl php7.1-gd php7.1-bcmath php7.1-dom php7.1-mbstring php7.1-xml php7.1-xmlrpc php7.1-zip php7.1-mysql php7.1-soap php7.1-intl php7.1-mcrypt php7.1-ldap php7.1-curl php7.1-mcrypt
#install php 5.6
sudo apt -y install php5.6 php5.6-fpm php5.6-cli php5.6-common php5.6-curl php5.6-gd php5.6-bcmath php5.6-dom php5.6-mbstring php5.6-xml php5.6-xmlrpc php5.6-zip php5.6-mysql php5.6-soap php5.6-intl php5.6-mcrypt php5.6-ldap php5.6-curl php5.6-mcrypt

#set PHP 7.1 as the active version as this is what valet-linux prefers to use at the moment
sudo update-alternatives --set php /usr/bin/php7.1

#install Magento Cloud CLI Tool
curl -sS https://accounts.magento.cloud/cli/installer | php

#install openconnect and the utility to use it with GP OKTA based authentication
sudo apt -y install gir1.2-webkit2-4.0 openconnect

#setup the user in mysql to work from anywhere with no password for easy access
sudo mysql -e "create user '$USER'@'%'; grant all on *.* to '$USER'@'%' with grant option; flush privileges;"

#increase the inotify limit to something a bit more reasonable
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

#install valet linux
composer global require cpriego/valet-linux

#run valet install and make a Code folder for storing project directories
valet install
mkdir ~/Code

#create our bash alias for changing PHP versions and connecting to the vpn
read -r -d '' BASH_ALIASES <<EOF
php-version () {
    if [ -z "\$1" ]; then
        echo "Usage: php-version <7.3|7.1|5.6>"
        echo "       Changes the current PHP version used by the system and valet-linux at the same time."
        php --version
        return 1
    fi
    sudo valet use \$1
    sudo update-alternatives --set php "/usr/bin/php\$1"
}

vpn-connect () {
    ${BASEDIR}/vpn-connect \$1
}
EOF
echo "$BASH_ALIASES" > ~/.bash_aliases

#reload bash
source ~/.bashrc

echo "
                                           ____                   _
                                          |  _ \  ___  _ __   ___| |
                                          | | | |/ _ \| '_ \ / _ \ |
                                          | |_| | (_) | | | |  __/_|
                                          |____/ \___/|_| |_|\___(_)"
echo "
                Please restart the system to make sure all software is completely initialized.

    Check out the README.md file for helpful tips, software, and instructions on how to use the built-in aliases."
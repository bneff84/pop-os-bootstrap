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

#create the vendor folder to store downloaded software
mkdir $BASEDIR/vendor

#add the lid state switch to kernelstub so we don't get stuck in a suspend loop after closing/opening the laptop lid
sudo kernelstub -a button.lid_init_state=open

#add custom repo for older versions of php
sudo add-apt-repository ppa:ondrej/php -y

# remove preinstalled stuff we don't need/want and cleanup any unused packages
sudo apt -y remove apache2 geary
sudo apt -y autoremove

#run an update of repos and upgrade any existing software with available upgrades before continuing
sudo apt update
sudo apt -y upgrade

#install all required software
#install mysql server, git, composer, dbeaver (DB GUI), evolution mail client and exchange web services, and dependencies for valet-linux
sudo apt -y install git jq xsel libnss3-tools composer mysql-server dbeaver-ce evolution evolution-ews redis python3-pip build-essential nodejs npm
#install node version manager (NVM)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
#install php 7.3
sudo apt -y install php7.3 php7.3-fpm php7.3-cli php7.3-common php7.3-curl php7.3-gd php7.3-bcmath php7.3-xml php7.3-mbstring php7.3-xml php7.3-xmlrpc php7.3-mysql php7.3-soap php7.3-intl php7.3-ldap php7.3-curl
#php 7.2 causes errors in valet-linux at the time of the creating of this tool, hence it not being included -- install at your own risk
sudo apt -y install php7.2 php7.2-fpm php7.2-cli php7.2-common php7.2-curl php7.2-gd php7.2-bcmath php7.2-xml php7.2-mbstring php7.2-xml php7.2-xmlrpc php7.2-zip php7.2-mysql php7.2-soap php7.2-intl php7.2-ldap php7.2-curl
#install php 7.1
sudo apt -y install php7.1 php7.1-fpm php7.1-cli php7.1-common php7.1-curl php7.1-gd php7.1-bcmath php7.1-dom php7.1-mbstring php7.1-xml php7.1-xmlrpc php7.1-zip php7.1-mysql php7.1-soap php7.1-intl php7.1-mcrypt php7.1-ldap php7.1-curl php7.1-mcrypt
#install php 5.6
sudo apt -y install php5.6 php5.6-fpm php5.6-cli php5.6-common php5.6-curl php5.6-gd php5.6-bcmath php5.6-dom php5.6-mbstring php5.6-xml php5.6-xmlrpc php5.6-zip php5.6-mysql php5.6-soap php5.6-intl php5.6-mcrypt php5.6-ldap php5.6-curl php5.6-mcrypt

#enable xdebug for all php versions
sudo apt -y install php-xdebug
read -r -d '' XDEBUG_CONFIG <<EOF
zend_extension=xdebug.so
xdebug.remote_enable=1
xdebug.remote_host=localhost
xdebug.remote_port=9000
xdebug.remote_autostart=1
xdebug.idekey=PHPSTORM
EOF
sudo echo "$XDEBUG_CONFIG" > /etc/php/7.3/mods-available/xdebug.ini
sudo echo "$XDEBUG_CONFIG" > /etc/php/7.2/mods-available/xdebug.ini
sudo echo "$XDEBUG_CONFIG" > /etc/php/7.1/mods-available/xdebug.ini
sudo echo "$XDEBUG_CONFIG" > /etc/php/5.6/mods-available/xdebug.ini

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

#download magerun
wget https://files.magerun.net/n98-magerun.phar -O $BASEDIR/helpers/magerun
chmod +x $BASEDIR/helpers/magerun
sudo ln -s $BASEDIR/helpers/magerun /usr/local/bin/magerun

#download magerun2
wget https://files.magerun.net/n98-magerun2.phar -O $BASEDIR/helpers/magerun2
chmod +x $BASEDIR/helpers/magerun2
sudo ln -s $BASEDIR/helpers/magerun2 /usr/local/bin/magerun2

#download wp-cli
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O $BASEDIR/helpers/wp-cli
chmod +x $BASEDIR/helpers/wp-cli
sudo ln -s $BASEDIR/helpers/wp-cli /usr/local/bin/wp-cli

#install sshmenu
pip3 install sshmenu

#install postman
sudo apt install libgconf-2-4
mkdir $BASEDIR/vendor/postman
wget https://dl.pstmn.io/download/latest/linux64 -O $BASEDIR/vendor/postman-latest.tar.gz
#this should create a new folder called Postman
tar -xf $BASEDIR/vendor/postman-latest.tar.gz
#create the desktop file for the app so we can use the launcher after a relog
read -r -d '' POSTMAN_DESKTOP <<EOF
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=$BASEDIR/vendor/Postman/app/Postman %U
Icon=$BASEDIR/vendor/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOF
echo "$POSTMAN_DESKTOP" > ~/.local/share/applications/postman.desktop

#set up helper scripts in /usr/local/bin
sudo ln -s $BASEDIR/helpers/vpn-connect /usr/local/bin/vpn-connect
sudo ln -s $BASEDIR/helpers/php-version /usr/local/bin/php-version
sudo ln -s $BASEDIR/helpers/mageclean /usr/local/bin/mageclean
sudo ln -s $BASEDIR/helpers/mageafterpull /usr/local/bin/mageafterpull
sudo ln -s $BASEDIR/helpers/magelocalize /usr/local/bin/magelocalize
sudo ln -s ~/.local/bin/sshmenu /usr/local/bin/sshmenu

#install valet linux
composer global require cpriego/valet-linux

#run valet install and make a Code folder for storing project directories
valet install
mkdir ~/Code

#overwrite the default valet binary with our custom one to force it to always run with php 7.2
sudo rm -f /usr/local/bin/valet
sudo ln -s $BASEDIR/helpers/valet /usr/local/bin/valet

#add a default nginx config file for valet to increase fastcgi buffer size
echo "fastcgi_buffers 16 16k;
fastcgi_buffer_size 32k;" > ~/.valet/Nginx/00-global

echo "
                                           ____                   _
                                          |  _ \  ___  _ __   ___| |
                                          | | | |/ _ \| '_ \ / _ \ |
                                          | |_| | (_) | | | |  __/_|
                                          |____/ \___/|_| |_|\___(_)"
echo "
                Please restart the system to make sure all software is completely initialized.

    Check out the README.md file for helpful tips, software, and instructions on how to use the built-in aliases."
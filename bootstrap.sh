#!/bin/bash

#set the target distro version
TARGET_DISTRO_VERSION="Pop!_OS 20.04 LTS"

#get the current distro version
DISTRO_VERSION="$( lsb_release -d -s )"

if [ "$DISTRO_VERSION" != "$TARGET_DISTRO_VERSION" ]; then
  echo "This script is intended for use on $TARGET_DISTRO_VERSION. Your version appears to be $DISTRO_VERSION."
  echo "It is recommended that you abort this installation as this script WILL install and remove packages"
  echo "that will likely break your installation if you are not on the appropriate version of the OS."
  echo ""
  echo "<<< CONTINUE AT YOUR OWN RISK >>>"
  echo ""
  read -p "Press [enter] to continue or ctrl-c to exit"
fi

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

               ____                ___  ____  _    ____              _       _
              |  _ \ ___  _ __    / _ \/ ___|| |  | __ )  ___   ___ | |_ ___| |_ _ __ __ _ _ __
              | |_) / _ \| '_ \  | | | \___ \| |  |  _ \ / _ \ / _ \| __/ __| __| '__/ _\` | '_ \\
              |  __/ (_) | |_) | | |_| |___) |_|  | |_) | (_) | (_) | |_\__ \ |_| | | (_| | |_) |
              |_|   \___/| .__/___\___/|____/(_)  |____/ \___/ \___/ \__|___/\__|_|  \__,_| .__/
                         |_| |_____|                                                      |_|

This is NOT an un-attended installation script. The majority of the installation can continue without your
input, but there may be action needed by you to confirm sudo access along the way. With a good internet connection
this process should only take a few minutes to complete. Please sit tight. Your patience will be rewarded!"
read -p "Press [enter] to continue or ctrl-c to exit"

#create the vendor folder to store downloaded software
mkdir "$BASEDIR"/vendor

#add custom repo for older versions of php
sudo add-apt-repository ppa:ondrej/php -y

#add repo for latest builds of openconnect
sudo add-apt-repository 'deb http://ppa.launchpad.net/dwmw2/openconnect/ubuntu bionic main'

#add the old ubuntu bionic repo for mysql 5.7, install it, then remove this repo
echo "deb http://us.archive.ubuntu.com/ubuntu/ bionic restricted main
deb http://us.archive.ubuntu.com/ubuntu/ bionic-security restricted main
" | sudo tee /etc/apt/sources.list.d/bionic.list
sudo apt update
sudo apt -y install mysql-server-5.7
sudo rm -f /etc/apt/sources.list.d/bionic.list

# remove preinstalled stuff we don't need/want and cleanup any unused packages
sudo apt -y remove apache2 geary
sudo apt -y autoremove

#run an update of repos and upgrade any existing software with available upgrades before continuing
sudo apt update
sudo apt -y upgrade

#install all required software
#install git, dbeaver (DB GUI), evolution mail client and exchange web services, and dependencies for valet-linux
sudo apt -y install git jq xsel libnss3-tools dbeaver-ce evolution evolution-ews redis python3-pip build-essential nodejs npm
#install node version manager (NVM)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
#install php 7.3
sudo apt -y install php7.3 php7.3-fpm php7.3-cli php7.3-common php7.3-curl php7.3-gd php7.3-bcmath php7.3-xml php7.3-mbstring php7.3-xml php7.3-xmlrpc php7.3-zip php7.3-mysql php7.3-soap php7.3-intl php7.3-ldap php7.3-curl
#install php 7.2
sudo apt -y install php7.2 php7.2-fpm php7.2-cli php7.2-common php7.2-curl php7.2-gd php7.2-bcmath php7.2-xml php7.2-mbstring php7.2-xml php7.2-xmlrpc php7.2-zip php7.2-mysql php7.2-soap php7.2-intl php7.2-ldap php7.2-curl
#install php 7.1
sudo apt -y install php7.1 php7.1-fpm php7.1-cli php7.1-common php7.1-curl php7.1-gd php7.1-bcmath php7.1-dom php7.1-mbstring php7.1-xml php7.1-xmlrpc php7.1-zip php7.1-mysql php7.1-soap php7.1-intl php7.1-mcrypt php7.1-ldap php7.1-curl php7.1-mcrypt
#install php 7.0
sudo apt -y install php7.0 php7.0-fpm php7.0-cli php7.0-common php7.0-curl php7.0-gd php7.0-bcmath php7.0-dom php7.0-mbstring php7.0-xml php7.0-xmlrpc php7.0-zip php7.0-mysql php7.0-soap php7.0-intl php7.0-mcrypt php7.0-ldap php7.0-curl php7.0-mcrypt
#install php 5.6
sudo apt -y install php5.6 php5.6-fpm php5.6-cli php5.6-common php5.6-curl php5.6-gd php5.6-bcmath php5.6-dom php5.6-mbstring php5.6-xml php5.6-xmlrpc php5.6-zip php5.6-mysql php5.6-soap php5.6-intl php5.6-mcrypt php5.6-ldap php5.6-curl php5.6-mcrypt

#download and install composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv ./composer.phar "$BASEDIR"/helpers/composer
chmod +x "$BASEDIR"/helpers/composer
sudo ln -s "$BASEDIR"/helpers/composer /usr/local/bin/composer

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
sudo echo "$XDEBUG_CONFIG" | sudo tee /etc/php/7.3/mods-available/xdebug.ini
sudo echo "$XDEBUG_CONFIG" | sudo tee /etc/php/7.2/mods-available/xdebug.ini
sudo echo "$XDEBUG_CONFIG" | sudo tee /etc/php/7.1/mods-available/xdebug.ini
sudo echo "$XDEBUG_CONFIG" | sudo tee /etc/php/7.0/mods-available/xdebug.ini
sudo echo "$XDEBUG_CONFIG" | sudo tee /etc/php/5.6/mods-available/xdebug.ini

#set PHP 7.2 as the active version as this is what valet-linux prefers to use at the moment
sudo update-alternatives --set php /usr/bin/php7.2

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
wget https://files.magerun.net/n98-magerun.phar -O "$BASEDIR"/helpers/magerun
chmod +x "$BASEDIR"/helpers/magerun
sudo ln -s "$BASEDIR"/helpers/magerun /usr/local/bin/magerun

#download magerun2
wget https://files.magerun.net/n98-magerun2.phar -O "$BASEDIR"/helpers/magerun2
chmod +x "$BASEDIR"/helpers/magerun2
sudo ln -s "$BASEDIR"/helpers/magerun2 /usr/local/bin/magerun2

#download wp-cli
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O "$BASEDIR"/helpers/wp-cli
chmod +x "$BASEDIR"/helpers/wp-cli
sudo ln -s "$BASEDIR"/helpers/wp-cli /usr/local/bin/wp-cli

#install sshmenu
pip3 install sshmenu

#install postman
sudo apt -y install libgconf-2-4
mkdir "$BASEDIR"/vendor/postman
wget https://dl.pstmn.io/download/latest/linux64 -O "$BASEDIR"/vendor/postman/postman-latest.tar.gz
#this should create a new folder called Postman
tar -C "$BASEDIR"/vendor/postman -xf "$BASEDIR"/vendor/postman/postman-latest.tar.gz
#create the desktop file for the app so we can use the launcher after a relog
read -r -d '' POSTMAN_DESKTOP <<EOF
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=$BASEDIR/vendor/postman/Postman/app/Postman %U
Icon=$BASEDIR/vendor/postman/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOF
echo "$POSTMAN_DESKTOP" > ~/.local/share/applications/postman.desktop

#set up helper scripts in /usr/local/bin
sudo ln -s "$BASEDIR"/helpers/vpn-connect /usr/local/bin/vpn-connect
sudo ln -s "$BASEDIR"/helpers/php-version /usr/local/bin/php-version
sudo ln -s "$BASEDIR"/helpers/mageclean /usr/local/bin/mageclean
sudo ln -s "$BASEDIR"/helpers/mageafterpull /usr/local/bin/mageafterpull
sudo ln -s "$BASEDIR"/helpers/magelocalize /usr/local/bin/magelocalize
sudo ln -s "$BASEDIR"/helpers/mageimport /usr/local/bin/mageimport
sudo ln -s "$BASEDIR"/helpers/sslcheck /usr/local/bin/sslcheck
sudo ln -s "$BASEDIR"/helpers/inotify-consumers /usr/local/bin/inotify-consumers
sudo ln -s ~/.local/bin/sshmenu /usr/local/bin/sshmenu

#install valet linux version 1.0 or higher so we can downgrade to one that support PHP 5.6 when needed
composer global require cpriego/valet-linux:">=1.0"

#add composer bin to path and reload .bashrc
echo "
#START POP_OS Bootstrap
export PATH="$PATH:$HOME/.config/composer/vendor/bin"
#END POP_OS Bootstrap" >> ~/.bashrc
source ~/.bashrc

#run valet install and make a Code folder for storing project directories
valet install
mkdir ~/Code

#overwrite the default valet binary with our custom one to force it to always run with php 7.2
sudo rm -f /usr/local/bin/valet
sudo ln -s "$BASEDIR"/helpers/valet /usr/local/bin/valet

#add a default nginx config file for valet to increase fastcgi buffer size and timeouts
echo "fastcgi_buffers 16 16k;
fastcgi_buffer_size 32k;
fastcgi_send_timeout 300s;
fastcgi_read_timeout 300s;
proxy_send_timeout 300s;
proxy_read_timeout 300s;
" > ~/.valet/Nginx/00-global

#install the go language and mailhog
sudo apt -y install golang-go
wget https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64 -O "$BASEDIR"/vendor/mailhog
chmod +x "$BASEDIR"/vendor/mailhog
sudo ln -s "$BASEDIR"/vendor/mailhog /usr/local/bin/mailhog

#install mailhog as a service
sudo tee /etc/systemd/system/mailhog.service <<EOL
[Unit]
Description=Mailhog
After=network.target
[Service]
User=$USER
ExecStart=/usr/bin/env /usr/local/bin/mailhog > /dev/null 2>&1 &
[Install]
WantedBy=multi-user.target
EOL
sudo systemctl daemon-reload
sudo systemctl enable mailhog
sudo systemctl start mailhog

# setup sendmail for PHP 5.6
if [ -f /etc/php/5.6/fpm/php.ini ]; then
  sudo sed -i "s/;sendmail_path.*/sendmail_path='\/usr\/local\/bin\/mailhog sendmail dev@example.com'/" /etc/php/5.6/fpm/php.ini
fi
if [ -f /etc/php/5.6/cli/php.ini ]; then
  sudo sed -i "s/;sendmail_path.*/sendmail_path='\/usr\/local\/bin\/mailhog sendmail dev@example.com'/" /etc/php/5.6/cli/php.ini
fi

# setup sendmail for PHP 7.0
if [ -f /etc/php/7.0/fpm/php.ini ]; then
  sudo sed -i "s/;sendmail_path.*/sendmail_path='\/usr\/local\/bin\/mailhog sendmail dev@example.com'/" /etc/php/7.0/fpm/php.ini
fi
if [ -f /etc/php/7.0/cli/php.ini ]; then
  sudo sed -i "s/;sendmail_path.*/sendmail_path='\/usr\/local\/bin\/mailhog sendmail dev@example.com'/" /etc/php/7.0/cli/php.ini
fi

# setup sendmail for PHP 7.1
if [ -f /etc/php/7.1/fpm/php.ini ]; then
  sudo sed -i "s/;sendmail_path.*/sendmail_path='\/usr\/local\/bin\/mailhog sendmail dev@example.com'/" /etc/php/7.1/fpm/php.ini
fi
if [ -f /etc/php/7.1/cli/php.ini ]; then
  sudo sed -i "s/;sendmail_path.*/sendmail_path='\/usr\/local\/bin\/mailhog sendmail dev@example.com'/" /etc/php/7.1/cli/php.ini
fi

# setup sendmail for PHP 7.2
if [ -f /etc/php/7.2/fpm/php.ini ]; then
  sudo sed -i "s/;sendmail_path.*/sendmail_path='\/usr\/local\/bin\/mailhog sendmail dev@example.com'/" /etc/php/7.2/fpm/php.ini
fi
if [ -f /etc/php/7.2/cli/php.ini ]; then
  sudo sed -i "s/;sendmail_path.*/sendmail_path='\/usr\/local\/bin\/mailhog sendmail dev@example.com'/" /etc/php/7.2/cli/php.ini
fi

# setup sendmail for PHP 7.3
if [ -f /etc/php/7.3/fpm/php.ini ]; then
  sudo sed -i "s/;sendmail_path.*/sendmail_path='\/usr\/local\/bin\/mailhog sendmail dev@example.com'/" /etc/php/7.3/fpm/php.ini
fi
if [ -f /etc/php/7.3/cli/php.ini ]; then
  sudo sed -i "s/;sendmail_path.*/sendmail_path='\/usr\/local\/bin\/mailhog sendmail dev@example.com'/" /etc/php/7.3/cli/php.ini
fi

# setup sendmail for PHP 7.4
if [ -f /etc/php/7.4/fpm/php.ini ]; then
  sudo sed -i "s/;sendmail_path.*/sendmail_path='\/usr\/local\/bin\/mailhog sendmail dev@example.com'/" /etc/php/7.4/fpm/php.ini
fi
if [ -f /etc/php/7.4/cli/php.ini ]; then
  sudo sed -i "s/;sendmail_path.*/sendmail_path='\/usr\/local\/bin\/mailhog sendmail dev@example.com'/" /etc/php/7.4/cli/php.ini
fi

echo "
                                           ____                   _
                                          |  _ \  ___  _ __   ___| |
                                          | | | |/ _ \| '_ \ / _ \ |
                                          | |_| | (_) | | | |  __/_|
                                          |____/ \___/|_| |_|\___(_)"
echo "
                Please restart the system to make sure all software is completely initialized.

    Check out the README.md file for helpful tips, software, and instructions on how to use the built-in aliases."
# Pop_OS! 19.04 Bootstrap Project
 
This repo contains a few files intended to make setting up a brand new development environment on Pop_OS! 19.04 quick
and easy.

I work primarily as a Magento developer. So this bootstrap may include some software (like the Magento Cloud CLI Tool)
that you don't need. Feel free to customize this to your liking, and happy coding!

## Installation

To use, just install Pop!_OS 19.04, clone the repo to a local folder, and run the `bootstrap.sh` script from the command
line. The bootstrap script will automatically download and configure software to get you up and running quickly.
* [Valet Linux](https://github.com/cpriego/valet-linux) - Lightning fast, low-memory local development using PHP/Nginx
* [OpenConnect 8](https://github.com/dlenski/openconnect) - Command-line VPN Utility with GlobalProtect Support
* [DBeaver](https://dbeaver.io/) - Database Management GUI for many popular databases
* [Magento Cloud CLI Tool](https://devdocs.magento.com/guides/v2.3/cloud/before/before-workspace-magento-prereqs.html#cloud-ssh-cli-cli-install) - Used for working on Magento Cloud Projects
* MySQL Server - SQL-based RDBMS
* Git - Version Control
* Composer - Package Manager for PHP Projects
* PHP 7.3
* PHP 7.1
* PHP 5.6

## Changing PHP Versions
To change PHP versions, use the Bash Alias `php-version` which will allow you to easily swap between PHP versions for
both valet and CLI. If you ever need to change **just** the CLI version for any reason, you can do this with the
`sudo update-alternatives --set php /usr/bin/php7.1` command. Just swap out `7.1` for the version you'd like to use
(it has to already be installed).

## Connecting to a GlobalProtect VPN with web-based authentication
I connect to a GlobalProtect VPN for my current job, so this bootstrap script includes some setup to allow this to work
on Pop!_OS for me out of the box. If you use a GlobalProtect VPN with web-based authentication, this **should** work for
you as well, but I've only tested it with my own personal use case.

To connect to the VPN, open a new terminal window and run the `vpn-connect` bash alias created by the bootstrap script.
This will open a WebKit headless browser window via the `gp-saml-gui.py` [helper script](https://github.com/dlenski/gp-saml-gui)
, which will allow you to authenticate using web-based auth. The helper will grab the authentication cookie returned by your
web-based sign-on provider and pass it to the OpenConnect CLI call to log you into the VPN.

The `vpnc-script` included has been altered from the version packaged with OpenConnect, and should be used. It resolves
a compatibility issue that prevented the VPN's DNS servers from taking precedence over the ones defined by the local
network.

## Recommended Software
While I've included most of the "major" software, there are some packages that are not automatically installed, but
are very helpful programs to improve the development experience. Pop_OS! Sits on top of Ubuntu, which is Debian based.
So in general, any `.deb` package installer **should** work and any software you may use on Ubuntu **should** be
compatible.
* [GitKraken](https://www.gitkraken.com/) - Git GUI, Merge/Diff Tool, Repo Browser
* [JetBrains Toolbox](https://www.jetbrains.com/toolbox-app/) - Simple Widget-like Utility for managing/installing
JetBrains software like PHPStorm and other IntelliJ IDEA Platform tools
* [Google Chrome](https://www.google.com/chrome/) - Google's Web Browser based on Chromium - Don't forget you can
"install" many web-applications built using PWA architecture (like Office 365/Outlook) so they run like native apps
* [Slack](https://slack.com/downloads/linux) - Work chat for your whole team!
* Pop!_Shop - Basically a GUI for the command line package manager. Allows you to browse available software and install
or remove programs. Definitely worth a look for quick applications you might need access to without downloading a `.deb`
installer.

## Useful Tips
### Keyboard Shortcuts
Pop! comes with a lot of helpful keyboard shortcuts built in right off the bat. Many of these provide similar
functionality to that of a certain fruit-based computer. An up-to-date listing of these can always be found on the
[Pop!_OS Website](https://pop.system76.com/docs/keyboard-shortcuts/) but some of the more common ones are outlined here.
Your "super" key is the "Windows" key on most US keyboards.
* `Tap the Super Key` - Activities Overview - Shows thumbnails of all open windows and allows global search
* `Super + V` - Open/Close Calendar/Notifications Tray
* `Super + T` - Open a new Terminal window
* `Super + Up Arrow`/`Super + Down Arrow` - Change your virtual desktop workspace
* `Ctrl + Super + Up Arrow` - Maximize/Restore current window on current workspace
* `Ctrl + Super + Left Arrow`/`Ctrl + Super + Right Arrow` - Move window to left/right half of the current workspace
* `Ctrl + Super + Shift + Left Arrow`/`Ctrl + Super + Shift + Right Arrow` - Move window left/right to the next display
(multiple monitors)
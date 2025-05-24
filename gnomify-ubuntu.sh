#!/usr/bin/env bash

remove_ubuntu_default_apps() {
    ubuntu-report send no
    apt remove \
        ubuntu-session \
        ubuntu-report \
        ubuntu-gnome-wallpapers* \
        ubuntu-pro-client* \
        ubuntu-wallpapers* \
        ubuntu-advantage* \
        gnome-terminal \
        yaru-theme-gnome-shell \
        yaru-theme-gtk \
        yaru-theme-icon \
        yaru-theme-sound \
        rhythmbox* \
        apport* \
        eog \
        evince -y
    
    # Removing random desktop shortcuts.
    rm /usr/share/applications/info.desktop
    rm /usr/share/applications/display-im7.q16.desktop
}

remove_snaps() {
    while [ "$(snap list | wc -l)" -gt 0 ]; do
        for snap in $(snap list | tail -n +2 | cut -d ' ' -f 1); do
            snap remove --purge "$snap"
        done
    done

    systemctl stop snapd
    systemctl disable snapd
    systemctl mask snapd
    apt purge snapd -y
    rm -rf /snap /var/snap /var/lib/snapd
    for userpath in /home/*; do
        rm -rf $userpath/snap
    done
    cat <<-EOF | tee /etc/apt/preferences.d/nosnap.pref
	Package: snapd
	Pin: release a=*
	Pin-Priority: -10
	EOF
}

remove_terminal_ads() {
    sed -i 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news
    pro config set apt_news=false
}

update_system() {
    apt update & apt upgrade --auto-remove -y
}

cleanup() {
    flatpak uninstall org.gtk.Gtk3theme.Yaru -y
    apt autoremove -y
}

setup_flathub() {
    # Install flatpak and setup the flathub repo
    apt install flatpak -y
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    apt install --no-install-recommends gnome-software-plugin-flatpak -y
}

setup_vanilla_gnome() {
    apt install qgnomeplatform-qt5 -y
    
    # Install gnome session, icons and fonts
    apt install \
        gdm3 \
        gnome-session \
        gnome-backgrounds \
        gnome-keyring \
        gnome-keyring-pkcs11 \
        vanilla-gnome-default-settings \
        fonts-inter -y
}

setup_gnome_apps() {
    # install gnome core applications that are listed here: https://apps.gnome.org/

    apt install \
        gnome-calculator \
        gnome-calendar \
        gnome-snapshot \
        gnome-characters \
        gnome-clocks \
        gnome-connections \
        gnome-console \
        gnome-contacts \
        baobab \
        gnome-disk-utility \
        simple-scan \
        evince \
        gnome-shell-extensions \
        gnome-font-viewer \
        loupe \
        gnome-logs \
        gnome-maps \
        gnome-music \
        gnome-software \
        gnome-text-editor \
        showtime \
        gnome-weather \
        gnome-tweaks \
        gnome-sushi \
        gnome-software-plugin-deb \
        gnome-shell-extension-manager -y

    # Gnome Decibels is not available from the ubuntu packages.  
    flatpak install org.gnome.Decibels -y
}

setup_desktop() { 
    gsettings_wrapper set org.gnome.shell.extensions.ding show-home false
    gsettings_wrapper set org.gnome.shell.extensions.ding show-trash false
    
    gsettings_wrapper set org.gnome.desktop.interface gtk-theme Adwaita-dark
    gsettings_wrapper set org.gnome.desktop.interface color-scheme prefer-dark
    gsettings_wrapper set org.gnome.desktop.interface icon-theme Papirus

    gsettings_wrapper set org.gnome.desktop.interface font-name 'Inter Variable 11'
    gsettings_wrapper set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/gnome/blobs-l.svg'
    gsettings_wrapper set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/gnome/blobs-l.svg'

    gnome_extensions_wrapper enable ding@rastersoft.com
    gnome_extensions_wrapper disable ubuntu-appindicators@ubuntu.com 
    gnome_extensions_wrapper disable ubuntu-dock@ubuntu.com
    gnome_extensions_wrapper disable tiling-assistant@ubuntu.com
}

install_icons() {
    # Source: https://github.com/PapirusDevelopmentTeam/papirus-icon-theme
    add-apt-repository -y ppa:papirus/papirus
    apt-get update
    apt-get install \
        papirus-icon-theme \
        adwaita-icon-theme -y 
}

install_firefox() {
    # Install firefrox from their own repository
    apt purge firefox -y
    snap remove --purge firefox
    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- > /etc/apt/keyrings/packages.mozilla.org.asc
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" > /etc/apt/sources.list.d/mozilla.list 
    echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' > /etc/apt/preferences.d/mozilla
    apt update
    apt install firefox -y
}

gsettings_wrapper() {
    if ! command -v dbus-launch; then
        sudo apt install dbus-x11 -y
    fi
    sudo -Hu $(logname) dbus-launch gsettings "$@"
}

gnome_extensions_wrapper() {
    if ! command -v dbus-launch; then
        sudo apt install dbus-x11 -y
    fi
    sudo -Hu $(logname) dbus-launch gnome-extensions "$@"
}

ask_reboot() {
    echo 'Reboot now? (y/n)'
    while true; do
        read choice
        if [[ "$choice" == 'y' || "$choice" == 'Y' ]]; then
            reboot
            exit 0
        fi
        if [[ "$choice" == 'n' || "$choice" == 'N' ]]; then
            break
        fi
    done
}

msg() {
    tput setaf 2
    echo "[*] $1"
    tput sgr0
}

error_msg() {
    tput setaf 1
    echo "[!] $1"
    tput sgr0
}

check_root_user() {
    if [ "$(id -u)" != 0 ]; then
        echo 'Please run the script as root!'
        echo 'We need to do administrative tasks'
        exit
    fi
}

print_banner() {
    echo '
   █████████                                     ███    ██████             
  ███░░░░░███                                   ░░░    ███░░███            
 ███     ░░░ ████████    ██████  █████████████  ████  ░███ ░░░█████ ████   
░███        ░░███░░███  ███░░███░░███░░███░░███░░███ ███████ ░░███ ░███    
░███    █████░███ ░███ ░███ ░███ ░███ ░███ ░███ ░███░░░███░   ░███ ░███    
░░███  ░░███ ░███ ░███ ░███ ░███ ░███ ░███ ░███ ░███  ░███    ░███ ░███    
 ░░█████████ ████ █████░░██████  █████░███ ██████████ █████   ░░███████    
  ░░░░░░░░░ ░░░░ ░░░░░  ░░░░░░  ░░░░░ ░░░ ░░░░░░░░░░ ░░░░░     ░░░░░███    
    █████  ██████████                          █████           ███ ░███    
   ░░███  ░░███░░███                          ░░███           ░░██████     
    ░███   ░███ ░███████  █████ ████████████  ███████  █████ ████░░░░      
    ░███   ░███ ░███░░███░░███ ░███░░███░░███░░░███░  ░░███ ░███           
    ░███   ░███ ░███ ░███ ░███ ░███ ░███ ░███  ░███    ░███ ░███           
    ░███   ░███ ░███ ░███ ░███ ░███ ░███ ░███  ░███ ███░███ ░███           
    ░░████████  ████████  ░░████████████ █████ ░░█████ ░░████████          
     ░░░░░░░░  ░░░░░░░░    ░░░░░░░░░░░░ ░░░░░   ░░░░░   ░░░░░░░░           
                                                                           
 Gnomify Ubuntu - A script to make Ubuntu look like Gnome
 By: @SirBisgaard | v 0.1.4         
    '                                                                                                       
}

show_menu() {
    echo ' Menu: '
    echo '   1 - Gnomify Ubuntu'
    echo '   q - Exit' 
    echo
}

main() {
    check_root_user
    while true; do
        print_banner
        show_menu
        read -p 'Enter your choice: ' choice
        case $choice in
        1)
            auto
            msg 'Done!'
            ask_reboot
            ;;
    
        q)
            exit 0
            ;;

        *)
            error_msg 'Wrong input!'
            ;;
        esac
    done
}

auto() {
    msg 'Updating system'
    update_system
    msg 'Removing Ubuntu default apps'
    remove_ubuntu_default_apps
    msg 'Removing terminal ads (if they are enabled)'
    remove_terminal_ads
    msg 'Removing snap & snap apps'
    remove_snaps
    msg 'Installing Firefox from mozilla repository'
    install_firefox
    msg 'Installing vanilla icons and Papirus icons'
    install_icons
    msg 'Installing vanilla Gnome session'
    setup_vanilla_gnome
    msg 'Setting up Gnome desktop'
    setup_desktop
    msg 'Installing flatpak and flathub'
    setup_flathub
    msg 'Installing Gnome apps'
    setup_gnome_apps
    msg 'Cleaning up'
    cleanup
}

(return 2> /dev/null) || main

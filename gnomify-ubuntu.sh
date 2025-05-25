#!/usr/bin/env bash
version="0.1.7"

update_system() {
    apt update && apt upgrade --auto-remove -y
}

remove_ubuntu_and_install_vanilla_gnome() {
    ubuntu-report send no

    # Removing random apps
    apt remove sysprof -y
    apt remove ptyxis -y
    apt remove rhythmbox* -y
    apt remove evince -y

    apt install qgnomeplatform-qt5 -y
    apt install qgnomeplatform-qt6 -y

    apt remove \
        ubuntu-session \
        ubuntu-report \
        gnome-terminal \
        yaru-theme* \
        apport* \
        eog -y

    apt install \
        gnome-session \
        gnome-software \
        gnome-backgrounds \
        gnome-keyring \
        gnome-keyring-pkcs11 \
        vanilla-gnome-default-settings \
        fonts-cantarell \
        fonts-inter -y 
    
    # Remove Ubuntu specific desktop files
    rm /usr/share/applications/info.desktop
    rm /usr/share/applications/display-im7.q16.desktop
}

remove_terminal_ads() {
    sed -i 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news
    pro config set apt_news=false
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

setup_firefox() {
    # Install firefrox from their own repository
    apt purge firefox -y
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

setup_icons() {
    # Source: https://github.com/PapirusDevelopmentTeam/papirus-icon-theme
    add-apt-repository -y ppa:papirus/papirus
    apt update
    apt install \
        papirus-icon-theme \
        adwaita-icon-theme -y 
}

setup_flathub() {
    # Install flatpak and setup the flathub repo
    apt install flatpak -y
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    apt install --no-install-recommends gnome-software-plugin-flatpak -y
}

setup_gnome_apps() {
    # install gnome core applications that are listed here: https://apps.gnome.org/
    
    # Map: apt package name -> flatpak ID
    declare -A GNOME_APPS=(
        [gnome-decibels]=org.gnome.Decibels
        [gnome-calculator]=org.gnome.Calculator
        [gnome-calendar]=org.gnome.Calendar
        [gnome-snapshot]=org.gnome.Snapshot
        [gnome-characters]=org.gnome.Characters
        [gnome-clocks]=org.gnome.Clocks
        [gnome-connections]=org.gnome.Connections
        [gnome-console]=
        [gnome-contacts]=org.gnome.Contacts
        [baobab]=org.gnome.baobab
        [gnome-disk-utility]=
        [simple-scan]=org.gnome.SimpleScan
        [evince]=org.gnome.Evince
        [gnome-shell-extensions]=org.gnome.Extensions
        [gnome-font-viewer]=org.gnome.font-viewer
        [loupe]=org.gnome.Loupe
        [gnome-logs]=org.gnome.Logs
        [gnome-maps]=org.gnome.Maps
        [gnome-music]=org.gnome.Music
        [gnome-software]=
        [gnome-text-editor]=org.gnome.TextEditor
        [showtime]=org.gnome.Showtime
        [gnome-weather]=org.gnome.Weather
        [gnome-tweaks]=
        [gnome-sushi]=
        [gnome-software-plugin-deb]=
        [gnome-shell-extension-manager]=com.mattjakeman.ExtensionManager
    )

    for pkg in "${!GNOME_APPS[@]}"; do
        if apt info "$pkg" >/dev/null 2>&1; then
            apt install --no-install-recommends "$pkg" -y
        elif [[ -n "${GNOME_APPS[$pkg]}" ]]; then
            flatpak install -y flathub "${GNOME_APPS[$pkg]}"
        fi
    done

    flatpak uninstall org.gtk.Gtk3theme.Yaru -y
}

setup_desktop() { 
    gsettings_wrapper set org.gnome.shell.extensions.ding show-home false
    gsettings_wrapper set org.gnome.shell.extensions.ding show-trash false
    
    gsettings_wrapper set org.gnome.desktop.interface gtk-theme Adwaita-dark
    gsettings_wrapper set org.gnome.desktop.interface color-scheme prefer-dark
    gsettings_wrapper set org.gnome.desktop.interface icon-theme Papirus
    gsettings_wrapper set org.gnome.desktop.interface accent-color "blue"

    gsettings_wrapper set org.gnome.desktop.interface font-name 'Inter Variable 11'
    gsettings_wrapper set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/gnome/blobs-l.svg'
    gsettings_wrapper set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/gnome/blobs-l.svg'

    gnome_extensions_wrapper enable ding@rastersoft.com
    gnome_extensions_wrapper disable ubuntu-appindicators@ubuntu.com 
    gnome_extensions_wrapper disable ubuntu-dock@ubuntu.com
    gnome_extensions_wrapper disable tiling-assistant@ubuntu.com
}

cleanup() {
    apt autoremove -y
}

# Wrapper functions to run gsettings and gnome-extensions as the logged in user

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
 By: @SirBisgaard | ' $version '         
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
    msg 'Removing Ubuntu and installing vanilla Gnome'
    remove_ubuntu_and_install_vanilla_gnome
    msg 'Removing terminal ads (if they are enabled)'
    remove_terminal_ads
    msg 'Removing snap & snap apps'
    remove_snaps
    msg 'Installing Firefox from mozilla repository'
    setup_firefox
    msg 'Installing vanilla icons and Papirus icons'
    setup_icons
    msg 'Installing flatpak and flathub'
    setup_flathub
    msg 'Installing Gnome apps'
    setup_gnome_apps
    msg 'Setting up Gnome desktop'
    setup_desktop
    msg 'Cleaning up'
    cleanup
}

(return 2> /dev/null) || main

# 🚀 Gnomify Ubuntu


**Seamlessly blend Ubuntu’s renowned stability with the clean, modern GNOME desktop and its default applications.**


## ✨ What is Gnomify Ubuntu?

Gnomify Ubuntu is a script that transforms Ubuntu into a near-vanilla GNOME experience, replacing Ubuntu’s customizations and non-GNOME applications with the official GNOME interface and apps. This project is perfect for users who want the reliability of Ubuntu paired with the simplicity and elegance of upstream GNOME.

## 🎯 Who is this for?

- **GNOME enthusiasts** who want a true GNOME experience on Ubuntu.
- **Minimalists** seeking a clean, distraction-free desktop.
- **Tinkerers** who want to avoid Snap, Ubuntu ads, and telemetry.
- **Anyone** who prefers Flatpak and Flathub over Snap.


## 🖼️ Screenshots

### Main Menu

This is how the script's main menu looks when you run it. You can choose to install Gnomify Ubuntu, or exit the script:

<img src="https://raw.githubusercontent.com/SirBisgaard/Gnomify-Ubuntu/refs/heads/master/menu.png" width="800" alt="Gnomify Ubuntu Menu" />

### Desktop Previews

Here are screenshots of the desktop after running Gnomify Ubuntu on different versions of Ubuntu. The desktop features the Papirus icon theme, Adwaita/Libadwaita themes, and a clean GNOME interface.

**Ubuntu 25.04 Desktop**

<img src="https://raw.githubusercontent.com/SirBisgaard/Gnomify-Ubuntu/refs/heads/master/screenshot_25_04.png" width="800" alt="Ubuntu 25.04 Desktop Preview" />


**Ubuntu 24.04.2 LTS Desktop**

<img src="https://raw.githubusercontent.com/SirBisgaard/Gnomify-Ubuntu/refs/heads/master/screenshot_24_04.png" width="800" alt="Ubuntu 24.04.2 LTS Desktop Preview" />


## ⚡ Features

- 🚫 **Removes Ubuntu Desktop** and related none GNOME apps
- 🚫 **Removes Snap** and all Snap packages
- 🖥️ **Installs GNOME Desktop** (session, backgrounds, tweaks, etc.)
- 🛠️ **Installs GNOME Core apps** (see script for full list)
- 🌐 **Installs Firefox** directly from Mozilla’s official repository
- 🏪 **Installs Flathub** for access to thousands of Flatpak apps
- 🎨 **Enables Papirus & adw-gtk3 theme** for a modern feel
- 🌙 **Enables dark mode** and other defaults for a great start!
- 📦 **Updates with Ubuntu** throught their updater  
- 🧹 **Cleans up** after itself for a tidy system


## 🛠️ Installation

> **Recommended:** A fresh install of Ubuntu, and preferably with third-party repositories and additional media formats enabled during installation.

1. **Open a terminal** and run:
    ```bash
    sudo bash -c "$(wget -qO- https://raw.githubusercontent.com/SirBisgaard/Gnomify-Ubuntu/master/gnomify-ubuntu.sh)"
    ```

2. **Check the version number:**  
   The script should display the version number listed in the script header.

3. **Ubuntu crrash report:**  
   If you see a message about Ubuntu crash reports, you can safely ignore it. This is a known issue with the script and does not affect functionality.

4. **Reboot your computer** after the script completes.

> **⚠️ Use this script at your own risk.**  
> It makes significant changes to your system.

## ✅ Tested On

This script has been tested on the latest Ubuntu releases to ensure compatibility and stability. 
Below are the versions confirmed to work:

| Distro                 | Status |
| ---------------------- | :----: | 
| **Ubuntu 25.04**       | ✅     |
| **Ubuntu 24.04.2 LTS** | ✅     |


## 🙋 FAQ

**Q: Can I customize what gets installed or removed?**  
A: Yes! The script is modular—edit `gnomify-ubuntu.sh` to suit your needs.

**Q: Is this reversible?**  
A: No. The changes are significant. Back up your data before running.

**Q: Does this work on Ubuntu flavors (Kubuntu, Xubuntu, etc.)?**  
A: Only tested on standard Ubuntu. Use at your own risk on other flavors.

**Q: Is adw-gtk3 updated automaticly?**  
A: No, you will have to update it manually, an I hope to add this in the future.

## 🤝 Credits

- Created by [@SirBisgaard](https://github.com/SirBisgaard)
- Inspired by [@polkaulfield](https://github.com/polkaulfield) / [ubuntu-debullshit](https://github.com/polkaulfield/ubuntu-debullshit)
- Thanks to dev @ [adw-gtk3](https://github.com/lassekongo83/adw-gtk3) for the Adwaita GTK3 theme
- Thanks to [GNOME](https://www.gnome.org/) and [Ubuntu](https://ubuntu.com/) for their amazing work!

 **📄 [License](LICENSE)**


Enjoy your clean GNOME desktop! 🎉
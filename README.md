# 🚀 Gnomify Ubuntu

**Seamlessly blend Ubuntu’s renowned stability with the clean, modern GNOME desktop and its default applications.**

---

## ✨ What is Gnomify Ubuntu?

Gnomify Ubuntu is a script that transforms Ubuntu into a near-vanilla GNOME experience, replacing Ubuntu’s customizations and non-GNOME applications with the official GNOME interface and apps. This project is perfect for users who want the reliability of Ubuntu paired with the simplicity and elegance of upstream GNOME.

---


## 🎯 Who is this for?

- **GNOME enthusiasts** who want a true GNOME experience on Ubuntu.
- **Minimalists** seeking a clean, distraction-free desktop.
- **Tinkerers** who want to avoid Snap, Ubuntu ads, and telemetry.
- **Anyone** who prefers Flatpak and Flathub over Snap.

---

## 🖼️ Screenshots

### Main Menu

This is how the script's main menu looks when you run it. You can choose to install Gnomify Ubuntu, or exit the script:

<img src="https://raw.githubusercontent.com/SirBisgaard/Gnomify-Ubuntu/refs/heads/master/menu.png" width="800" alt="Gnomify Ubuntu Menu" />

### Desktop Preview

A fresh Ubuntu 25.04 desktop after running Gnomify Ubuntu, featuring the Papirus icon theme and default GNOME wallpaper:

<img src="https://raw.githubusercontent.com/SirBisgaard/Gnomify-Ubuntu/refs/heads/master/screenshot.png" width="800" alt="Gnomify Ubuntu Desktop Preview" />

---

## ⚡ Features

- 🚫 **Removes Snap** and all Snap packages
- 🚫 **Disables terminal ads** and Ubuntu telemetry
- 🚫 **Removes Ubuntu desktop environment** and non-GNOME default applications
- 🖥️ **Installs near-vanilla GNOME** (session, backgrounds, tweaks, etc.)
- 🛠️ **Installs essential GNOME apps** (see script for full list)
- 🛒 **Installs GNOME Software Center** with Flatpak support
- 🎨 **Applies Papirus icon theme** and enables it by default
- 🌙 **Enables dark mode** and Adwaita/Libadwaita themes
- 🔌 **Installs Extension Manager** for easy GNOME extension management
- 🌐 **Installs Firefox** directly from Mozilla’s official repository
- 🧩 **Disables Ubuntu-specific extensions** but enables desktop icons
- 🏪 **Enables Flathub** for access to thousands of Flatpak apps
- 🧹 **Cleans up** after itself for a tidy system

---

## 🛠️ Installation

> **Recommended:** Start with a minimal install of the latest Ubuntu version.

1. **Open a terminal** and run:
    ```bash
    sudo bash -c "$(wget -qO- https://raw.githubusercontent.com/SirBisgaard/Gnomify-Ubuntu/master/gnomify-ubuntu.sh)"
    ```

2. **Check the version number:**  
   The script should display: **v 0.1.4**

3. **Reboot your computer** after the script completes.

> **⚠️ Use this script at your own risk.**  
> It makes significant changes to your system.

---

## 📋 What does the script do?

- Updates your system
- Removes Snap, Ubuntu session, telemetry, and bloat
- Installs GNOME session, core apps, and tweaks
- Sets up Flatpak and Flathub
- Installs Papirus and Adwaita icon themes
- Installs Firefox from Mozilla’s repo
- Applies dark mode and modern GNOME theming
- Cleans up and prompts for reboot

For a detailed breakdown, [read the script](gnomify-ubuntu.sh) or run it interactively to see each step.

---

## ✅ Tested On

| Distro           | Status |
| ---------------- | :----: | 
| **Ubuntu 25.04** | ✅     |
| **Ubuntu 24.04** | ✅     |
| **Ubuntu 23.10** | ⛔     |
| **Ubuntu 23.04** | ⛔     |

---

## 🙋 FAQ

**Q: Can I customize what gets installed or removed?**  
A: Yes! The script is modular—edit `gnomify-ubuntu.sh` to suit your needs.

**Q: Is this reversible?**  
A: No. The changes are significant. Back up your data before running.

**Q: Does this work on Ubuntu flavors (Kubuntu, Xubuntu, etc.)?**  
A: Only tested on standard Ubuntu. Use at your own risk on other flavors.

---

## 🤝 Credits

- Created by [@SirBisgaard](https://github.com/SirBisgaard)
- Thanks to the GNOME and Ubuntu communities

 **📄 [License](LICENSE)**

---

Enjoy your clean GNOME desktop! 🎉
#!/bin/bash

sudo emerge -av rofi pcmanfm-qt app-text/zathura app-text/zathura-meta app-office/libreoffice-bin www-client/firefox-bin media-video/ffmpeg app-eselect/eselect-repository dev-vcs/git

sudo eselect repository add brave-overlay git https://gitlab.com/jason.oliveira/brave-overlay.git
sudo emerge --sync brave-overlay
sudo emerge --ask --verbose www-client/brave-bin::brave-overlay
echo "dev-libs/libpthread-stubs **" | sudo tee -a /etc/portage/package.accept_keywords/libpthread
sudo emerge --ask --verbose www-client/brave-bin::brave-overlay

sudo emerge -av www-client/chromium


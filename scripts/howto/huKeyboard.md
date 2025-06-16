# Setting the Hungarian keyboard in X:

Create /etc/X11/xorg.conf.d/00-keyboard.conf

Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "hu"
    Option "XkbOptions" "ctrl:nocaps"
EndSection

The "ctrl:nocaps" option switches CapsLock to Ctrl

The full list of options can be found in:
/usr/share/X11/xkb/rules/evdev.lst

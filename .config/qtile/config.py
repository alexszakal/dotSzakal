# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
import subprocess

mod = "mod4"
terminal = guess_terminal()

colors = {
    "dark": "#1d2021",
    "light": "#fbf1c7",
    "accent": "#fe8019",
    "inactive": "#928374",
    "active": "#83a598",
    "urgent": "#fb4934"
}

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # Screen navigation
    Key([mod], "period", lazy.next_screen(), desc="Move focus to next screen"),
    Key([mod], "comma", lazy.prev_screen(), desc="Move focus to previous screen"),
    Key([mod, "shift"], "period", lazy.window.toscreen(1), desc="Move window to next screen"),
    Key([mod, "shift"], "comma", lazy.window.toscreen(0), desc="Move window to previous screen"),

    # Lock screen
    Key([mod], "l", lazy.spawn("slock"), desc="Lock screen"),
    
]


groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),   # gitk
        Match(wm_class="dialog"),         # dialog boxes
        Match(wm_class="download"),       # downloads
        Match(wm_class="error"),          # error msgs
        Match(wm_class="file_progress"),  # file progress boxes
        Match(wm_class='kdenlive'),       # kdenlive
        Match(wm_class="makebranch"),     # gitk
        Match(wm_class="maketag"),        # gitk
        Match(wm_class="notification"),   # notifications
        Match(wm_class='pinentry-gtk-2'), # GPG key password entry
        Match(wm_class="ssh-askpass"),    # ssh-askpass
        Match(wm_class="toolbar"),        # toolbars
        Match(wm_class="Yad"),            # yad boxes
        Match(wm_class="fiji-Main"),            # yad boxes
        Match(title="branchdialog"),      # gitk
        Match(title='Confirmation'),      # tastyworks exit box
        Match(title='Qalculate!'),        # qalculate-gtk
        Match(title="pinentry"),          # GPG key password entry
        Match(title="tastycharts"),       # tastytrade pop-out charts
        Match(title="tastytrade"),        # tastytrade pop-out side gutter
        Match(title="tastytrade - Portfolio Report"), # tastytrade pop-out allocation
        Match(wm_class="tasty.javafx.launcher.LauncherFxApp"), # tastytrade settings
    ]
)

layouts = [
    layout.MonadTall(),
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

def get_connected_screens():
    """
    Detect connected screens using xrandr and return their information.
    Returns a list of dictionaries with screen information.
    """
    try:
        # Run xrandr to get screen information
        result = subprocess.run(['xrandr', '--query'], capture_output=True, text=True)
        
        if result.returncode != 0:
            print("Error running xrandr:", result.stderr)
            return [{"name": "default", "primary": True}]
        
        screens = []
        lines = result.stdout.strip().split('\n')
        
        for line in lines:
            if ' connected' in line:
                parts = line.split()
                screen_name = parts[0]
                is_primary = 'primary' in line
                
                # Check if screen has geometry information
                geometry_info = None
                for part in parts:
                    if 'x' in part and '+' in part:
                        geometry_info = part
                        break
                
                screens.append({
                    "name": screen_name,
                    "primary": is_primary,
                    "geometry": geometry_info,
                    "connected": True
                })
        
        # Sort screens: primary first, then by name
        screens.sort(key=lambda x: (not x["primary"], x["name"]))
        
        # If no screens detected, return default
        if not screens:
            screens = [{"name": "default", "primary": True}]
            
        print(f"Detected {len(screens)} connected screens:")
        for i, screen in enumerate(screens):
            print(f"  Screen {i}: {screen['name']} ({'primary' if screen['primary'] else 'secondary'})")
            
        return screens
        
    except Exception as e:
        print(f"Error detecting screens: {e}")
        return [{"name": "default", "primary": True}]

def create_bar(is_primary=True):
    """Create a bar configuration, with different widgets based on primary/secondary status."""
    widgets = [
        widget.CurrentLayout(
            foreground=colors["accent"],
            padding=10
        ),
        widget.GroupBox(
            active=colors["active"],
            inactive=colors["inactive"],
            highlight_method="block",
            block_highlight_text_color=colors["dark"],
            this_current_screen_border=colors["accent"],
            other_current_screen_border=colors["inactive"],
            padding=5,
            fontsize=14
        ),
        widget.Prompt(
            foreground=colors["accent"]
        ),
        widget.WindowName(
            foreground=colors["light"],
            max_chars=50
        ),
        widget.Chord(
            chords_colors={
                "launch": (colors["urgent"], colors["light"]),
            },
            name_transform=lambda name: name.upper(),
        ),
        widget.Spacer(),
    ]
    
    # Add system widgets only to primary screen
    if is_primary:
        widgets.extend([
            widget.Systray(
                padding=5
            ),
            widget.Sep(
                linewidth=2,
                foreground=colors["inactive"]
            ),
            widget.CPU(
                format="CPU: {load_percent}%",
                foreground=colors["active"],
                padding=5
            ),
            widget.Memory(
                format="RAM: {MemUsed:.0f}{mm}",
                foreground=colors["active"],
                padding=5
            ),
            widget.Sep(
                linewidth=2,
                foreground=colors["inactive"]
            ),
            widget.Volume(
                foreground=colors["accent"],
                padding=5
            ),
            widget.Sep(
                linewidth=2,
                foreground=colors["inactive"]
            ),
        ])
    
    # Add clock and screen info to all screens
    widgets.extend([
        widget.Clock(
            format="%Y-%m-%d %a %I:%M %p",
            foreground=colors["light"],
            padding=10
        ),
        widget.CurrentScreen(
            active_color=colors["accent"],
            inactive_color=colors["inactive"],
            padding=5
        ),
    ])
    
    return bar.Bar(
        widgets,
        30,
        background=colors["dark"],
        margin=[4, 4, 0, 4]  # top, right, bottom, left
    )

def create_screens():
    """Create Screen objects based on detected displays."""
    connected_screens = get_connected_screens()
    qtile_screens = []
    
    for i, screen_info in enumerate(connected_screens):
        is_primary = screen_info.get("primary", i == 0)
        
        screen = Screen(
            top=create_bar(is_primary=is_primary),
#            wallpaper="~/.config/qtile/wallpaper.jpg",  # Optional: set wallpaper path
#            wallpaper_mode="fill",
        )
        
        qtile_screens.append(screen)
    
    return qtile_screens

# Create screens dynamically
screens = create_screens()

#screens = [
#    Screen(
#        bottom=bar.Bar(
#            [
#                widget.CurrentLayout(),
#                widget.GroupBox(),
#                widget.Prompt(),
#                widget.WindowName(),
#                widget.Chord(
#                    chords_colors={
#                        "launch": ("#ff0000", "#ffffff"),
#                    },
#                    name_transform=lambda name: name.upper(),
#                ),
#                widget.TextBox("default config", name="default"),
#                widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
#                widget.Systray(),
#                widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
#                widget.QuickExit(),
#            ],
#            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
#        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
#    ),
#]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
bring_front_click = True
floats_kept_above = True
cursor_warp = False

auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

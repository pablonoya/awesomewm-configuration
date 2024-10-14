# awesomewm-configuration

[![awesome-rice-badge](https://raw.githubusercontent.com/zemmsoares/awesome-rices/main/assets/awesome-rice-badge.svg)](https://github.com/zemmsoares/awesome-rices)
[![works badge](https://cdn.jsdelivr.net/gh/nikku/works-on-my-machine@v0.2.0/badge.svg)](https://github.com/nikku/works-on-my-machine)

My personal AwesomeWM configuration for work and daily tasks 👨🏼‍💻

![full_screenshot](./screenshots/full.png)

### ℹ️ Details

---

- 🐧 **OS:** EndeavourOS
- 🌙 **Icons:** [Küyen](https://gitlab.com/froodo_alexis/kuyen-icons)
- 🔡 **Fonts**
  - Regular: [Manrope](https://www.gent.media/manrope)
  - Monospace: [JetBrains Mono Slashed](https://github.com/sharpjs/JetBrainsMonoSlashed#installation)
  - Icons: [Material Symbols Rounded](https://github.com/google/material-design-icons/tree/master/variablefont) and [jetbrains-mono-nerd](https://archlinux.org/packages/community/any/ttf-jetbrains-mono-nerd/)
- ▶ Video wallpaper [here](https://mylivewallpapers.com/sci-fi/pixel-cyberpunk-metropolis-animated-wallpaper/)
- 📄 Rest of .dotfiles [here](https://github.com/pablonoya/dotfiles)

### ✨ Features

---

- 🎨 Custom color scheme taken from [Xresources](https://github.com/pablonoya/dotfiles/blob/main/Xresources), available as vscode theme [here](https://github.com/pablonoya/seramuriana).
- 💻🖥 Multiple screen support (vertical screen in progress).
- 🎬 Simple animations with [Rubato](https://github.com/andOrlando/rubato) and this [picom fork](https://github.com/fdev31/picom).

#### Optional features

- ⏯ Auto-pausing video wallpaper.
- 🌦 Weather popup widget.
- 🎶 Media controls using dominant colors of from cover art.
- 📅 Google Calendar events.

### ⚙ Installation

---

Tested on Asus G14 (2020) with EndeavourOS

Install dependencies

```sh
pikaur -S awesome-git \
acpi acpid acpi_call upower \
pipewire pipewire-alsa pipewire-pulse playerctl pamixer jq \
brightnessctl networkmanager \

# autostarted
polkit-gnome blueman network-manager-applet redshift-minimal \
picom-simpleanims-git diodon fusuma ulauncher \

# extra packages
lxappearance-gtk3 qt5ct-kde \
flameshot pavucontrol asusctl rog-control-center \

# for optional features
mpv xwinwrap-git \
python-pipx \
gcalendar \

--needed
```

Clone the proyect

```sh
git clone --recurse-submodules https://github.com/pablonoya/awesomewm-configuration
```

To obtain the color theme, copy or replace my [Xresources file](https://github.com/pablonoya/dotfiles/blob/main/Xresources) to

```sh
$HOME/.Xresources
```

Move the configuration folder to awesome directory

```sh
mv awesomewm-configuration $HOME/.config/awesome
```

Set your latitude and longitude in `configuration/variables.lua` for redshift and the optional weather widget.

```lua
latitude = 12.345
longitude = -67.890
```

<details>
<summary><b>Activate the optional features</b></summary>

Set corresponding parameters `configuration/variables.lua`,

#### Auto pausing Video wallpaper

Set video paths, vertical video is optional and it's used on vertical screens.

```lua
-- Video wallpaper
videowallpaper_path = HOME .. "/videos/video-wallpaper.mp4"
videowallpaper_vertical_path = HOME .. "/videos/video-wallpaper-vertical.mp4"
```

#### Media controls with dominant colors

1. Install my [dominantcolors script](https://github.com/pablonoya/dominantcolors) with pipx.

```sh
pipx install git+https://github.com/pablonoya/dominantcolors.git
```

2. Set the script path.

```lua
-- Dominantcolors script path
dominantcolors_path = HOME .. "/.local/bin/dominantcolors",
```

#### Google Calendar events

Set gcalendar command with your account and output as json.

```lua
-- gcalendar requires output in json
gcalendar_command = "gcalendar --output json --no-of-days 3",
```

#### Weather

Set your [OpenWeather](https://openweathermap.org/) API key.

```lua
-- OpenWeather api key
weather_api_key = "y0ur4p1k3yc0m35h3r3"
```

</details>

### 🖼 Gallery

---

#### Information Docks: Calendar + Google calendar events, Weather and Notification Center

![info-docks](./screenshots/info-docks.png)

#### Control center

|                               Controls                                |                               Monitors                                |
| :-------------------------------------------------------------------: | :-------------------------------------------------------------------: |
| ![control_center_controls](./screenshots/control_center_controls.png) | ![control_center_monitors](./screenshots/control_center_monitors.png) |

#### Media controls with dominant colors in top bar and control center

![media_in_bar](./screenshots/media_in_bar.png)

![media_in_control_center](./screenshots/media_popup.png)

#### Combined taglist + tasklist with [Bling](https://github.com/BlingCorp/bling) previews

|                  Tag preview                  |                 Client preview                  |
| :-------------------------------------------: | :---------------------------------------------: |
| ![tag_preview](./screenshots/tag_preview.png) | ![task_preview](./screenshots/task_preview.png) |

#### Lockscreen with word clock colorized by time of day and widgets

| Morning                                                     | Evening                                                     |
| ----------------------------------------------------------- | ----------------------------------------------------------- |
| ![lockscreen_morning](./screenshots/lockscreen_morning.png) | ![lockscreen_evening](./screenshots/lockscreen_evening.png) |

#### Some popups

| Layout                                          | Brightness + Volume                                                                                               | Mic on/off                                                                |
| ----------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| ![popup_layout](./screenshots/popup_layout.png) | ![popup_brightness](./screenshots/popup_brightness.png) <br/> ![popup_brightness](./screenshots/popup_volume.png) | ![mic_on](./screenshots/mic_on.png) ![mic_off](./screenshots/mic_off.png) |

#### Keyboard shortcuts

![keyboard_shortcuts](./screenshots/keyboard_shortcuts.png)

#### Exit screen

![exit_screen](./screenshots/exit_screen.png)

### 💡 Acknowledgments

---

- [rxyhn](https://github.com/rxyhn)
- [elenapan](https://github.com/elenapan)
- [Crylia](https://github.com/Crylia)
- [Kasper24](https://github.com/Kasper24)

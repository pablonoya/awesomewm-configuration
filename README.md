# awesomewm-configuration
[![works badge](https://cdn.jsdelivr.net/gh/nikku/works-on-my-machine@v0.2.0/badge.svg)](https://github.com/nikku/works-on-my-machine)

My personal AwesomeWM configuration for work and daily tasks 👨🏼‍💻

![full_screenshot](https://user-images.githubusercontent.com/31524852/232510330-a812c5d7-f5e5-4aa3-a7d5-deb58a684390.png)


### ℹ️ Details
---
- 🐧 **OS:**  EndeavourOS
- 🧑‍💻 **Terminal:** Kitty
- 🌙 **Icons:** [Küyen](https://github.com/fabianalexisinostroza/Kuyen-icons)
- 🔡 **Fonts**
  - Regular: [Manrope](https://www.gent.media/manrope)
  - Monospace: [JetBrains Mono Slashed](https://github.com/sharpjs/JetBrainsMonoSlashed#installation)
  - Icons: [Material Design Icons](https://github.com/google/material-design-icons) and [jetbrains-mono-nerd](https://archlinux.org/packages/community/any/ttf-jetbrains-mono-nerd/)
- ▶ Wallpaper: "#8 Unicorn" by [Kanistra Studio](https://www.artstation.com/artwork/Bmd6zm)
- 📄 Rest of .dotfiles [here](https://github.com/pablonoya/dotfiles)


### ✨ Features
---
🎨 Custom color scheme taken from [Xresources](https://github.com/pablonoya/dotfiles/blob/main/Xresources), also available for vscode [here](https://github.com/pablonoya/seramuriana).  
💻🖥 Multiple screen support (vertical screen in progress).  
⏯ Auto-pausing video wallpaper.  
🎬 Simple animations with [Rubato](https://github.com/andOrlando/rubato) and this [picom fork](https://github.com/fdev31/picom).

<details>
<summary>How can I set the video wallpaper in another config?</summary>

Set video wallpaper using [Awesome Away](https://github.com/shmilee/awesome-away) with a custom window name
https://github.com/pablonoya/awesomewm-configuration/blob/ed0b10fff129717ab1ff3b48abc56d7197345cf8/configuration/video_wallpaper.lua#L15-L26

and autostart this small script
https://github.com/pablonoya/awesomewm-configuration/blob/ed0b10fff129717ab1ff3b48abc56d7197345cf8/configuration/pause_videowallpaper#L3-L12 
</details>


### ⚙ Installation
---
Tested on Asus G14 (2020) with EndeavourOS

Install dependencies
```sh
pikaur -S awesome-git picom-simpleanims-git \
acpi acpid acpi_call upower \
pipewire pipewire-alsa pipewire-pulse playerctl pamixer jq \
brightnessctl redshift-minimal \
bluez-utils networkmanager polkit-gnome xdotool \
mpv xwinwrap-git lxappearance-gtk3 qt5ct-kde \
blueman network-manager-applet flameshot diodon ulauncher pavucontrol \
asusctl rog-control-center --needed
```
</details>

Clone the proyect
```sh
git clone --recurse-submodules https://github.com/pablonoya/awesomewm-configuration
```

To obtain the colors, copy or replace my [Xresources file](https://github.com/pablonoya/dotfiles/blob/main/Xresources) to
```sh
$HOME/.Xresources
```

<details>
<summary>Optional: Replace the current configuration completely</summary>


```sh
mv awesomewm-configuration $HOME/.config/awesome
```
</details>


### 🖼 Gallery
---
#### Notification Center + Calendar  
![notif_center+calendar](https://user-images.githubusercontent.com/31524852/232395473-3699e4e0-58a9-41d6-a5a6-305284188977.png)

#### Control center
|Controls|Monitors|
|:-:|:-:|
|![control_center_controls](https://user-images.githubusercontent.com/31524852/232521407-83232103-e1d9-40d7-a2cd-07cf5ddcecd2.png)|![control_center_monitors](https://user-images.githubusercontent.com/31524852/232395856-87c766c4-1058-408c-84f6-e481d9f649cd.png)    |

#### Media controls in top bar
![media_in_bar](https://user-images.githubusercontent.com/31524852/232518944-3f5087f9-40a2-48a5-9b81-c66e2537b1b3.png)

#### Combined taglist + tasklist
![taglist](https://user-images.githubusercontent.com/31524852/232517286-68d3a288-2f5d-4302-bfdb-663334f63f8a.png)

With [Bling](https://github.com/BlingCorp/bling) previews!
|Tag preview|Client preview|
|:-:|:-:|
|![tag_preview](https://user-images.githubusercontent.com/31524852/232521049-1462738a-d58b-473e-a0b8-1fbc72b345bc.png)|![task_preview](https://user-images.githubusercontent.com/31524852/232521057-253397c9-d0bc-499a-aa86-6de24ca126fe.png)  |

#### Lockscreen with word clock colorized by time of day
|Dawn|Midday|Night
|---|---|---|
|![image](https://user-images.githubusercontent.com/31524852/235561130-92c58246-4922-4343-bec6-2c00ef49fe3b.png)|![image](https://user-images.githubusercontent.com/31524852/235560816-588185cc-9696-43c5-b4a6-3bd30a609116.png)|![image](https://user-images.githubusercontent.com/31524852/235561459-06d1b240-0eb5-4724-9dc4-c14b965776cc.png)|

#### Some popups
|Volume|Layout|Mic on/off|
|---|---|---|
|![popup_volume](https://user-images.githubusercontent.com/31524852/232397220-13c26fdc-1ff2-44de-ab4b-68bcbbd047e9.png)|![popup_layout](https://user-images.githubusercontent.com/31524852/232397568-cfee5823-bb7a-4713-a85e-3ccff91fcad3.png)|![mic_on](https://user-images.githubusercontent.com/31524852/232519388-a82a77af-2c01-416b-bbaa-f1e7547103bc.png) ![mic_off](https://user-images.githubusercontent.com/31524852/232519380-ef0ff15f-ad79-43fc-82f9-7346ebfd223f.png)|

#### Keyboard shortcuts
![keyboard_shortcuts](https://user-images.githubusercontent.com/31524852/232522652-dad0f836-6ea0-4d73-aa56-5ea85f241925.png)

#### Exit screen
![image](https://user-images.githubusercontent.com/31524852/235562950-17883931-ef68-4591-a528-f3675e054d2b.png)


### 🤍 Acknowledgments
---
- [rxyhn](https://github.com/rxyhn)
- [Crylia](https://github.com/Crylia)
- [Kasper24](https://github.com/Kasper24)
- [elenapan](https://github.com/elenapan)

## Setup
#### OS Image
- Burn Raspbian [lite] to sd card. Option: [Balena Etcher](https://www.balena.io/etcher/).
- Enable ssh: add file named `ssh` in `/boot`.
- Enable wifi: add file named `wpa_supplicant.conf` in `/boot` with the following:

```conf
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=US

network={
 ssid="<Name of your WiFi>"
 psk="<Password for your WiFi>"
}
```

## Installing packages
Run the following before installing new packages
```
sudo apt-get update && sudo apt-get upgrade
```

- neovim + init.vim + zplug + gawk (for fzf)
- git + create ssh key and add to github
- tmux + tmux.conf + tpm
- zsh + oh-my-zsh
  - `sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`
- neofetch

## Overclocking pi4
#### Info
TODO: add corresponding voltage values

#### Code
location: `/boot/config.txt`
```
# Overclocking
over_voltage=5.5
arm_freq=2000
#gpu_feq=600
```

## 3.5" TFT Display Module
#### Info
- https://github.com/goodtft/LCD-show
- https://diy.2pmc.net/3-5-inch-lcd-tft-screen-raspberry-pi-display-touch-install-fix-inverted-colors/
- model: xpt2046
- 3.5" capacative touchscreen

#### Code
location: `/boot/config.txt`
```
# copy pasted for 3.5" TFT LCD
dtoverlay=waveshare35c,fps=50,speed=24000000,debug=32:rotate=90
hdmi_force_hotplug=1
hdmi_group=2
hdmi_mode=1
hdmi_mode=87
hdmi_cvt 480 320 60 6 0 0 0
hdmi_drive=2
display_rotate=0
```

## Camera Module (WIP)
- enable camera using `sudo raspi-config`
- `raspistill [-vf -hf] <location>.png`

```camera.sh
#!/bin/bash

DATE=$(date +"%Y-%m-%d_%H%M")

# use -vf or -hf to flip the image
raspistill -o /home/pi/camera/$DATE.jpg
```

- timelapse
  - `raspistill -t 60000 -tl 1000 -o /home/pi/timelapse/image%04d.jpg`

- create video (ffmpeg)
  - `ffmpeg -r 10 -i image%04d.jpg -s 1280x720 -vcodec libx264 video.mp4`
  - where `10` is the fps

## Projects and links
- qbitorrent-nox https://www.joelj.net/raspberrypi/setup-qbittorrent-server-in-raspberry-pi/
`sudo chmod -R ugo+rw /path/to/share` 
- mount hard drive https://www.raspberrypi.org/documentation/configuration/external-storage.md
- auto mount hard drive https://www.raspberrypi.org/forums/viewtopic.php?t=205016
- remap keys https://raspberrypi.stackexchange.com/questions/5333/how-to-map-caps-lock-key-to-something-useful
- samba https://pimylifeup.com/raspberry-pi-samba/
- `sudo chown -R [pi user] /path/to/share`
- pi plex https://pimylifeup.com/raspberry-pi-plex-server/
- pihole https://pi-hole.net/

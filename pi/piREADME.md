Download and flash raspbian lite
- install ssh
- configure wifi

```
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=<Insert country code here>

network={
 ssid="<Name of your WiFi>"
 psk="<Password for your WiFi>"
}
```

Before install packages:
sudo apt-get update && sudo apt-get upgrade

sudo apt-get install
neovim
tmux + tmux.conf + tpm
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
git
zsh
ranger
oh-my-zsh
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```
zplug + gawk
neofetch

qbitorrent-nox https://www.joelj.net/raspberrypi/setup-qbittorrent-server-in-raspberry-pi/
`sudo chmod -R ugo+rw /path/to/share`
mount hard drive https://www.raspberrypi.org/documentation/configuration/external-storage.md
auto mount hard drive https://www.raspberrypi.org/forums/viewtopic.php?t=205016
remap keys https://raspberrypi.stackexchange.com/questions/5333/how-to-map-caps-lock-key-to-something-useful
samba https://pimylifeup.com/raspberry-pi-samba/
`sudo chown -R [pi user] /path/to/share`
pi plex https://pimylifeup.com/raspberry-pi-plex-server/

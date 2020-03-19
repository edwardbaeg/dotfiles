## Overclocking
location: `/boot/config.txt`

```
# Overclocking
over_voltage=5.5
arm_freq=2000
#gpu_feq=600
```

## Display Module
ref: https://github.com/goodtft/LCD-show
ref: https://diy.2pmc.net/3-5-inch-lcd-tft-screen-raspberry-pi-display-touch-install-fix-inverted-colors/
model: xpt2046
3.5" capacative touchscreen

location: `/boot/config.txt`

```
# copy pasted for LCD
dtoverlay=waveshare35c,fps=50,speed=24000000,debug=32:rotate=90
hdmi_force_hotplug=1
hdmi_group=2
hdmi_mode=1
hdmi_mode=87
hdmi_cvt 480 320 60 6 0 0 0
hdmi_drive=2
display_rotate=0
```

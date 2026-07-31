# Kanata

This is a powerful keyboard remapper.

## MacOS setup

- brew install
- add to privacy and security -> input monitoring -> press add
  - use command+shift+G keyboard shortcut to navigate to /opt/homebrew/bin/
- install driver, the specific version in the release notes
  - https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice
- TODO: set up as daemon so doesnt have to run each time
- run as `sudo kanata --cfg <file>`

## Configuration notes

- issue with media/special keys: https://github.com/jtroo/kanata/issues/1141#issuecomment-2231437088

## TODO

- add layer for special characters

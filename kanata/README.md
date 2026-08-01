# Kanata

This is a powerful keyboard remapper.

## MacOS setup

- install with brew `brew install kanata`
- add to privacy and security -> input monitoring -> press add
  - use command+shift+G keyboard shortcut to navigate to /opt/homebrew/bin/
- install driver, the specific version in the release notes
  - https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice
- run as `sudo kanata --cfg <file>`

## Configuration notes

- issue with media/special keys, resolved in configuration
  - https://github.com/jtroo/kanata/issues/1141#issuecomment-2231437088

## TODO

- add layer for special characters
- set up as daemon so doesnt have to run each time

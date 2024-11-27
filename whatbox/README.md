# Whatbox

Usage guide.

## Install programs manually

- ranger/yazi
- ncdu
- lazygit
- nvim

### How to install programs

Download the linux arch64 binary (check system arch with `uname -m` or `arch`)
```
wget <url>
```

Unpack the .tar.gz:
```
tar -xzf
```

Move executable to a directory in $PATH, eg, `/bin`
```
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/nvim-linux64/bin
```

## Unpack rar files

```
unrar x <file>.rar
```

## CLI FTP tool

Use `lftp`. Article [here](https://whatbox.ca/wiki/lftp).

Shortcut set up as `lftp whatbox`, or connect manually:
```
lftp sftp://<user>@proteus.whatbox.ca
```

Basic usage:
```
# remote navigation
ls, cd

# local navigation
!ls, lcd

# download file, download directory
pget, mirror <dir>

# upload file, upload directory
put, mirror <dir>

```

## Set up nginx web server to serve files over HTTP

Follow the nginx guide [here](https://whatbox.ca/wiki/Userland_Nginx).

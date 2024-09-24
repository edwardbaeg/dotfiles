## Install programs manually

### List
- ranger/yazi
- ncdu
- lazygit
- nvim

### To install programs

Download the linux64 binary (check system arch with uname -m)
```
wget <url>
```

Unpack the .tar.gz:
```
tar -xzf
```

Move executable to a directory in $PATH.

## Unpack files

```
unrar x <file>.rar
```

## FTP CLI

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

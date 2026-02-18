# Scripts

## daily-obsidian-commit

Automatically commits any uncommitted changes in the Obsidian vault (`~/Sync/Obsidian Vault/`) with the message `Chore: update`. Does nothing if there are no changes.

Scheduled via macOS launchd to run daily at 9:00 AM.

Files:
- `daily-obsidian-commit.sh` — the commit script
- `com.user.obsidian.dailycommit.plist` — launchd agent configuration (template)

### Enable

> **Note:** The plist contains hardcoded paths for `/Users/edwardbaeg`. Update these if using on a different machine.

Copy to the launchd agents directory and load:

```sh
cp $HOME/dev/dotfiles/scripts/com.user.obsidian.dailycommit.plist \
  $HOME/Library/LaunchAgents/com.user.obsidian.dailycommit.plist

launchctl load $HOME/Library/LaunchAgents/com.user.obsidian.dailycommit.plist
```

### Disable

```sh
# Unload (stops scheduling without deleting)
launchctl unload $HOME/Library/LaunchAgents/com.user.obsidian.dailycommit.plist

# Remove completely
rm $HOME/Library/LaunchAgents/com.user.obsidian.dailycommit.plist
```

### Check status

```sh
launchctl list | grep obsidian
```

Logs are written to `~/Library/Logs/obsidian-dailycommit.log` and `~/Library/Logs/obsidian-dailycommit.error`.

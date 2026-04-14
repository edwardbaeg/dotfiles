# Hammerspoon: Spotify Device Check on Wake

## Problem

When Spotify Connect is active, playback can be routed to a phone instead of the computer. After waking the laptop from sleep or unlocking the screen, there's no obvious visual indicator that audio is going to the wrong device.

## Goal

A Hammerspoon module that checks Spotify's active output device on wake/unlock and shows an alert if it's not the computer.

## Research Findings

### AppleScript is a dead end
Spotify's AppleScript dictionary (`sdef`) exposes NO device/output properties. Only `current track`, `sound volume`, `player state`, `player position`, `repeating`, `shuffling` are available. There is no way to determine which Spotify Connect device is active via osascript.

### Spotify Web API is the only viable approach
- `GET /v1/me/player` returns the active playback state including `device.type` ("Computer", "Smartphone", "Speaker", etc.) and `device.name`
- `GET /v1/me/player/devices` lists all available Spotify Connect devices
- Requires OAuth2 access token with `user-read-playback-state` scope
- Access tokens expire after 1 hour; refresh tokens are long-lived

### Alternative considered: `spotify_player` CLI
`brew install spotify_player` wraps the Web API and handles OAuth, but it's a full TUI client — overkill for just checking the active device. Direct HTTP via `hs.http.asyncGet` is simpler and has no external dependency.

## Design Decisions

- **Direct Web API via `hs.http.asyncGet`** — no external CLI dependency needed
- **Triggers on both `systemDidWake` AND `screensDidUnlock`** — covers lid open and lock screen scenarios
- **Runs on both personal and work machines** (no `isPersonal` guard)
- **Uses `toggleFeature.new()`** following `caffeine.lua` pattern — menubar indicator, URL events, persistent state
- **5-second delay** after wake/unlock before checking (network needs to reconnect)
- **30-second debounce** to prevent duplicate checks when wake + unlock fire close together

## Prerequisites (one-time manual setup)

1. Create a Spotify Developer App at https://developer.spotify.com/dashboard
2. Get `client_id` and `client_secret`
3. Run setup helper from Hammerspoon console to complete OAuth2 authorization

## Implementation Plan

### New file: `hammerspoon/spotify_device_check.lua`

**Token management:**
- Store `client_id`, `client_secret`, `refresh_token` in `hs.settings` (persists across reloads)
- Cache access token + expiry timestamp; auto-refresh when expired via `hs.http.asyncPost`
- Use `hs.base64.encode` for Basic auth header

**Wake/unlock watcher:**
- `hs.caffeinate.watcher` listening for `systemDidWake` and `screensDidUnlock`
- 5-second delay after event (`hs.timer.doAfter`) to let network reconnect
- Debounce: skip if last check was <30s ago
- Skip check if Spotify app isn't running (`hs.application.find("Spotify")`)

**Device check:**
- `hs.http.asyncGet` to `https://api.spotify.com/v1/me/player`
- 204 = nothing playing -> no alert
- 200 -> parse `device.type`; if not "Computer", show styled alert with device name
- 401 -> refresh token and retry (max 2 retries)
- Network error -> retry once after 5s

**Alert:** Styled `hs.alert.show()` with red-ish fill color, showing "Spotify playing on [type]: [name]", 5-second duration.

**Toggle feature:** `toggleFeature.new()` — menubar indicator "SD", URL events (`hammerspoon://spotifyDeviceCheck?action=toggle`), persistent enable/disable.

**Setup helpers:** Two global functions callable from Hammerspoon console:
- `SpotifyDeviceCheckSetup(clientId, clientSecret)` — stores credentials, opens auth URL in browser
- `SpotifyDeviceCheckExchangeCode(code)` — exchanges auth code for tokens, stores them

**Manual trigger:** URL event `hammerspoon://checkSpotifyDevice` for on-demand checking.

### Modify: `hammerspoon/init.lua`

Add `require("spotify_device_check")` after the existing module requires.

## Key patterns to follow

- `caffeine.lua` — primary reference for toggleFeature + watcher pattern
- `common/toggle_feature.lua` — abstraction providing menubar, persistence, URL events
- `url_listeners.lua` — reference for styled `hs.alert.show()` calls
- Global variable for watcher (not local) to prevent garbage collection (see `caffeine.lua:49`)

## Verification

1. Reload Hammerspoon config — "SD" in menubar, no console errors
2. Run `SpotifyDeviceCheckSetup(id, secret)` from console, complete OAuth flow
3. Open `hammerspoon://checkSpotifyDevice` in browser to trigger manual check
4. Verify alert appears when Spotify is playing to phone
5. Sleep laptop, wake, confirm check runs after 5s delay
6. Lock screen, unlock, confirm check also triggers
7. Toggle off via menubar click, verify wake no longer triggers check

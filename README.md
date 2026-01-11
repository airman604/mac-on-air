# Mac On Air

A Mac OS background service that monitors Mac camera state and sends webhook notifications to
[WLED](https://kno.wled.ge/) devices when the camera tuns on or off.

## Requirements

macOS 10.15+

## Usage

Xcode must be installed on your system to build `mac-on-air`. After cloning
this repository, run:

```sh
./install_service.sh WEBHOOK_URL
```

`WEBHOOK_URL` must be of the form `http://192.168.1.100/json/state` or
`http://wled-ID.local/json/state`. Replace the IP in the first form, or provide
the correct WLED ID in the second form (ID is 5 hex digits). You can find the
mDNS name and IP address of your WLED using `wled-native` mobile app that has
WLED discovery functionality.


The script will:
1. Build `MacOnAir`.
2. Copy the binary to `~/.local/bin/mac-on-air`
3. Create `~/Library/LaunchAgents/com.airman604.mac-on-air.plist` with a definition
of a launchd user agent.
4. Register the launchd user agent so that it starts automatically on login.

If you don't want it to be installed as an agent, build manually using:

```sh
swift build -c release
```

The binary will be located at `.build/release/MacOnAir`. Run manually:

```sh
.build/release/MacOnAir WEBHOOK_URL
```

### Webhook Call Format

The service sends JSON POST requests to the specified webhook URL:

- When camera is **ON**: `{"on": true}`
- When camera is **OFF**: `{"on": false}`

## Dependencies

- [is-camera-on](https://github.com/sindresorhus/is-camera-on) - Library for detecting Mac camera status

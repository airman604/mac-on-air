#!/bin/bash
set -e

# Check if WEBHOOK_URL is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <webhook-url>"
    exit 1
fi
WEBHOOK_URL=$1

swift build -c release
mkdir -p ~/.local/bin/
cp .build/release/MacOnAir ~/.local/bin/mac-on-air

mkdir -p ~/Library/LaunchAgents
mkdir -p ~/Library/Logs/com.airman604.mac-on-air

cat <<EOF > ~/Library/LaunchAgents/com.airman604.mac-on-air.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.airman604.mac-on-air</string>

    <key>ProgramArguments</key>
    <array>
      <string>$HOME/.local/bin/mac-on-air</string>
      <string>$WEBHOOK_URL</string>
    </array>

    <key>WorkingDirectory</key>
    <string>$HOME</string>

    <key>RunAtLoad</key>
    <true/>

    <key>KeepAlive</key>
    <true/>

    <key>StandardOutPath</key>
    <string>$HOME/Library/Logs/com.airman604.mac-on-air/stdout.log</string>

    <key>StandardErrorPath</key>
    <string>$HOME/Library/Logs/com.airman604.mac-on-air/stderr.log</string>
  </dict>
</plist>
EOF

launchctl bootstrap gui/$(id -u) "$HOME/Library/LaunchAgents/com.airman604.mac-on-air.plist"
launchctl kickstart -k "gui/$(id -u)/com.airman604.mac-on-air"

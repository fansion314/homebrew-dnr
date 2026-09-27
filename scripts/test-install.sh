#!/usr/bin/env bash
set -euo pipefail
test "$(uname -sm)" = 'Darwin arm64'
brew tap fansion314/dnr
brew trust fansion314/dnr
tap=$(brew --repository fansion314/dnr)
cp Formula/*.rb "$tap/Formula/"
mkdir -p "$tap/Casks"
cp Casks/*.rb "$tap/Casks/"
brew install --formula fansion314/dnr/dnr fansion314/dnr/pi-dnr
brew test fansion314/dnr/dnr
brew test fansion314/dnr/pi-dnr
brew install --cask fansion314/dnr/etcher-dnr
for app in /Applications/balenaEtcher.app; do
  codesign --verify --deep --strict "$app"
  test "$(plutil -extract DNRRuntimePath raw -o - "$app/Contents/Info.plist")" = dnr
  test "$(plutil -extract DNRLaunchMode raw -o - "$app/Contents/Info.plist")" = supervised
  if xattr -p com.apple.quarantine "$app" >/dev/null 2>&1; then exit 1; fi
done
dnr /Applications/balenaEtcher.app/Contents/Resources/application.dnp --self-test
pi --version

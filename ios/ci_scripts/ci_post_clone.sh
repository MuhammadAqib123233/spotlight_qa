#!/bin/sh
set -e

echo "Installing Flutter"

git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"

flutter --version

echo "Getting Flutter packages"
flutter pub get

echo "Generating iOS build files"
flutter build ios --release --no-codesign

# pod install

#!/bin/sh

set -e

echo "=== Installing Flutter ==="

# Install Flutter (adjust version to match your project)
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

echo "=== Flutter Doctor ==="
flutter doctor

echo "=== Installing pods and generating Flutter files ==="
cd $CI_PRIMARY_REPOSITORY_PATH
flutter pub get

cd ios
pod install --repo-update
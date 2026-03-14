#!/bin/sh
set -e

echo "Preparing Flutter project"

# Go to project root
cd $CI_PRIMARY_REPOSITORY_PATH

# Fetch dependencies
flutter pub get

# Generate iOS files
flutter build ios --release --no-codesign

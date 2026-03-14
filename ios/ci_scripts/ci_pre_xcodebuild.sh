# # #!/bin/sh

# # set -e

# # echo "=== Installing Flutter ==="

# # # Install Flutter (adjust version to match your project)
# # git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
# # export PATH="$PATH:$HOME/flutter/bin"

# # echo "=== Flutter Doctor ==="
# # flutter doctor

# # echo "=== Installing pods and generating Flutter files ==="
# # cd $CI_PRIMARY_REPOSITORY_PATH
# # flutter pub get

# # cd ios
# # pod install --repo-update

# #!/bin/sh

# # set -e

# # echo ">>> ci_pre_xcodebuild.sh started"

# # # ── Install Homebrew dependencies ──────────────────────────────
# # brew install cocoapods || true

# # # ── Flutter install ────────────────────────────────────────────
# # FLUTTER_VERSION="3.24.0"   # ← match your local flutter version exactly

# # git clone https://github.com/flutter/flutter.git \
# #   --depth 1 \
# #   -b $FLUTTER_VERSION \
# #   "$HOME/flutter"

# # export PATH="$PATH:$HOME/flutter/bin"

# # flutter --version

# # # ── Project setup ─────────────────────────────────────────────
# # cd "$CI_PRIMARY_REPOSITORY_PATH"

# # flutter pub get

# # # ── Generate the missing Swift Package ────────────────────────
# # cd ios

# # # This generates FlutterGeneratedPluginSwiftPackage
# # flutter build ios --config-only --no-codesign || true

# # pod install --repo-update

# # echo ">>> ci_pre_xcodebuild.sh completed"
# # ```

# # > **Key addition:** `flutter build ios --config-only --no-codesign` — this explicitly triggers generation of `FlutterGeneratedPluginSwiftPackage` without doing a full build.

# # ---

# # ## 4. Check your Xcode project settings

# # Open `ios/Runner.xcodeproj/project.pbxproj` and search for `FlutterGeneratedPluginSwiftPackage`. You'll see something like:
# # ```
# # path = ephemeral/Packages/FlutterGeneratedPluginSwiftPackage;

# #!/bin/sh
# set -e

# echo "Preparing Flutter project"

# # Go to project root
# cd $CI_PRIMARY_REPOSITORY_PATH

# # Fetch dependencies
# flutter pub get

# # Generate iOS files
# flutter build ios --release --no-codesign

echo "Skipping pre-build script"
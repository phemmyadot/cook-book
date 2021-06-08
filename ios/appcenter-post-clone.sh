#!/usr/bin/env bash
#Place this script in project/ios/

# fail if any command fails
set -e
# debug log
set -x

# sudo gem uninstall cocoapods
# pod setup

# sudo gem install cocoapods -v 1.7.5
# pod setup
# pod init
# pod 'AppCenter'
# pod install

cd ..
git clone -b stable https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH

flutter channel stable
flutter doctor
flutter pub get

echo "Installed flutter to `pwd`/flutter"
echo "APP_ENVIRONMENT : $APP_ENVIRONMENT"

flutter build ios --release --no-codesign --build-number $APPCENTER_BUILD_ID --target=lib/main.dart

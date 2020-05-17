### Qt is installed in:

/opt/Qt/5.12.4/android_armv7
/opt/Qt/5.12.4/android_arm64_v8a
/opt/Qt/5.12.6/android_armv7
/opt/Qt/5.12.6/android_arm64_v8a

### Android NDK (19c) is in

/opt/android/android-ndk

### Android SDK platform installed are

opt/android/android-sdk

Versions are:

android-28 and android-17

### So for qmake use something like the following:

// Set env variables

export ANDROID_NDK_HOST=linux-x86_64

// run qmake

/opt/Qt/5.12.6/android_armv7/bin/qmake -spec android-clang

// build the project

/opt/android/android-ndk/prebuilt/linux-x86_64/bin/make

// install

/opt/android/android-ndk/prebuilt/linux-x86_64/bin/make INSTALL_ROOT=android-build -f Makefile install

// Create the APK

/opt/Qt/5.12.6/android_armv7/bin/androiddeployqt --input android-lib<your_app_name>.so-deployment-settings.json --output android-build --android-platform android-28 --jdk $JAVA_HOME --gradle

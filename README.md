### Qt is installed in:

```
/opt/Qt/5.12.4/android_armv7
/opt/Qt/5.12.4/android_arm64_v8a
/opt/Qt/5.12.6/android_armv7
/opt/Qt/5.12.6/android_arm64_v8a
```

### Android NDK (19c) is in

`/opt/android/android-ndk`

### Android SDK platform installed are

`/opt/android/android-sdk`

### Versions are:

`android-28` and `android-17`

### The simplest use 

is to run the container by mounting your workspace in a volume and setting the working directory

```docker run --rm -v your_volume_mount -w your_workspace -e CONFIG=debug image:tag```

### Set env variables

You can optionnally override `QTDIR` which defaults to `/opt/Qt/5.12.6/android_armv7` by calling:
`docker run --rm -v your_volume_mount -w your_workspace -e CONFIG=debug -e QTDIR=/opt/Qt/5.12.6/android_arm64_v8a image:tag`

### You can also run commands separately inside the container.

First run and enter bash in the container:

```docker run --rm -ti -v your_volume_mount -w your_workspace -e --entrypoint bash image:tag```

For building with `qmake` the workflow would be something like the following:

```
// run qmake

/opt/Qt/5.12.6/android_armv7/bin/qmake -spec android-clang

// build the project

/opt/android/android-ndk/prebuilt/linux-x86_64/bin/make

// install

/opt/android/android-ndk/prebuilt/linux-x86_64/bin/make INSTALL_ROOT=android-build -f Makefile install

// Create the APK

/opt/Qt/5.12.6/android_armv7/bin/androiddeployqt --input android-lib<your_app_name>.so-deployment-settings.json --output android-build --android-platform android-28 --jdk $JAVA_HOME --gradle
```

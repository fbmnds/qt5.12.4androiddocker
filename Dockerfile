FROM ubuntu:18.04
LABEL "Maintainer"="Guenter Schwann"
LABEL "version"="0.3"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y build-essential git zip unzip bzip2 p7zip-full wget curl chrpath libxkbcommon-x11-0 && \
# Dependencies to create Android pkg
    apt-get install -y openjdk-8-jre openjdk-8-jdk openjdk-8-jdk-headless gradle

### Do not clean up
## && \
### Clean apt cache
##    apt-get clean && rm -rf /var/lib/apt/lists/*

# Build everything here
RUN mkdir -p /opt/android/android-sdk

# Install Android sdk
RUN wget -q https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
    unzip -q sdk-tools-linux-3859397.zip && \
    mv tools /opt/android/android-sdk && \
    rm sdk-tools-linux-3859397.zip

# Install Android ndk
RUN wget https://dl.google.com/android/repository/android-ndk-r19c-linux-x86_64.zip && \
    unzip -q android-ndk-r19c-linux-x86_64.zip && \
    mv android-ndk-r19c /opt/android/android-ndk && \
    rm android-ndk-r19c-linux-x86_64.zip

# Add Android tools and platform tools to PATH
ENV ANDROID_HOME /opt/android/android-sdk
ENV ANDROID_SDK_ROOT /opt/android/android-sdk
ENV ANDROID_NDK_ROOT /opt/android/android-ndk
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

ENV ANDROID_NDK_HOST linux-x86_64

# Install Android SDK
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses && $ANDROID_HOME/tools/bin/sdkmanager --update
RUN $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-17"
RUN $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-28"
RUN $ANDROID_HOME/tools/bin/sdkmanager "build-tools;28.0.3"

# Download / install Qt
####ADD https://code.qt.io/cgit/qbs/qbs.git/plain/scripts/install-qt.sh ./
COPY install-qt.sh /install-qt.sh
RUN bash install-qt.sh --version 5.12.4 --target android --toolchain android_armv7 qtbase qt3d qtdeclarative qtandroidextras qtconnectivity qtgamepad qtlocation qtmultimedia qtquickcontrols2 qtremoteobjects qtscxml qtsensors qtserialport qtsvg qtimageformats qttools qtspeech qtwebchannel qtwebsockets qtwebview qtxmlpatterns qttranslations && \
    bash install-qt.sh --version 5.12.4 --target android --toolchain android_arm64_v8a qtbase qt3d qtdeclarative qtandroidextras qtconnectivity qtgamepad qtlocation qtmultimedia qtquickcontrols2 qtremoteobjects qtscxml qtsensors qtserialport qtsvg qtimageformats qttools qtspeech qtwebchannel qtwebsockets qtwebview qtxmlpatterns qttranslations && \
    bash install-qt.sh --version 5.12.6 --target android --toolchain android_armv7 qtbase qt3d qtdeclarative qtandroidextras qtconnectivity qtgamepad qtlocation qtmultimedia qtquickcontrols2 qtremoteobjects qtscxml qtsensors qtserialport qtsvg qtimageformats qttools qtspeech qtwebchannel qtwebsockets qtwebview qtxmlpatterns qttranslations && \
    bash install-qt.sh --version 5.12.6 --target android --toolchain android_arm64_v8a qtbase qt3d qtdeclarative qtandroidextras qtconnectivity qtgamepad qtlocation qtmultimedia qtquickcontrols2 qtremoteobjects qtscxml qtsensors qtserialport qtsvg qtimageformats qttools qtspeech qtwebchannel qtwebsockets qtwebview qtxmlpatterns qttranslations

# Set the QTDIR environment variable
ENV QTDIR="/opt/Qt/5.12.6/android_armv7"

###===============================================================================
###===========   qt5-android17:latest   ==========================================
###===============================================================================
###  docker save qt5-android17 | gzip > qt5-android17_latest.tar.gz
FROM qt5-android17:latest
###===============================================================================

ENV DEBIAN_FRONTEND=noninteractive

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# Set the QTDIR environment variable
ENV QTDIR="/opt/Qt/5.12.6/android_armv7"

# Add Android tools and platform tools to PATH
ENV ANDROID_HOME /opt/android/android-sdk
ENV ANDROID_SDK_ROOT /opt/android/android-sdk
ENV ANDROID_NDK_ROOT /opt/android/android-ndk
ENV ANDROID_NDK_HOST linux-x86_64

ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools

# Add further dependencies
RUN apt-get update && \
    apt-get install -y make autoconf m4 clang gcc-multilib

# Add ECL, C++17 capable version
RUN cd /root && \
    git clone https://gitlab.com/embeddable-common-lisp/ecl.git && \
    cd ecl && \
    git checkout 0cc0fd914a8a18f64e5f1ee5d29e9479d394be39 && \
    rm -rf .git/ && \
    cd /root && \
    mv ecl ecl-0cc0

# Add customized LQML
RUN cd /root && \
    git clone https://github.com/fbmnds/control-ui-lqml.git

# Prepare ECL directories for cross compilation
RUN cd /root && \
    mkdir -p /root/ecl/android/ecl-android && \
    mkdir -p /root/ecl/android/ecl-android-host && \
    mkdir -p /root/ecl/android/32bit/ecl-android && \
    mkdir -p /root/ecl/android/32bit/ecl-android-host && \
    cp -r ecl-0cc0 ecl/android/ && \
    cp -r ecl-0cc0 ecl/android/32bit && \
    cd /root/control-ui-lqml/lqml/ && \
    cp platforms/android/build-ecl/*.sh /root/ecl/android && \
    cp platforms/android/build-ecl/32bit/*.sh /root/ecl/android/32bit/

# Compile host ECL
RUN cd /root/ecl-0cc0 &&\
    ./configure && \
    make && \
    make install && \
    rm -rf /root/ecl-0cc0

# Add cross-compiled ECL 64bit/32bit
ENV ANDROID_NDK_TOOLCHAIN=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64
RUN cd /root/ecl/android && \
    ./1-make-ecl-host.sh && \
    ./2-make-ecl-android.sh && \
    cd 32bit && \
    ./1-make-ecl-host.sh && \
    ./2-make-ecl-android.sh

ENV ECL_ANDROID=/root/ecl/android/ecl-android
ENV ECL_ANDROID_32=/root/ecl/android/32bit/ecl-android

COPY build.sh /build.sh

ENTRYPOINT /bin/bash /build.sh



# build an app in three steps
export PROJECT_DIR=/root/control-ui-lqml/lqml/apps/control-ui
cd $PROJECT_DIR/build-android

# 1. qmake
/opt/Qt/5.12.6/android_armv7/bin/qmake  "CONFIG+=32bit" ..

# 2. make
make clean && \
make install INSTALL_ROOT=$PROJECT_DIR/build-android/android-build/

# 3. androiddeployqt
/opt/Qt/5.12.6/android_armv7/bin/androiddeployqt \
  --input android-libapp.so-deployment-settings.json \
  --output android-build --android-platform android-17 --jdk $JAVA_HOME --gradle

### works for QML apps without ECL
### TODO: make it work for LQML
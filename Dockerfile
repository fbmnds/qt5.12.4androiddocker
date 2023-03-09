FROM ubuntu:18.04
LABEL "Maintainer"="Guenter Schwann"
LABEL "version"="0.3"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y build-essential git zip unzip bzip2 p7zip-full wget curl chrpath libxkbcommon-x11-0 && \
# Dependencies to create Android pkg
    apt-get install -y openjdk-8-jre openjdk-8-jdk openjdk-8-jdk-headless gradle

# Do not clean apt cache
#    apt-get clean && rm -rf /var/lib/apt/lists/*

# Build everything here
RUN mkdir -p /opt/android/android-sdk

# Install Android sdk
RUN wget -q https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
    unzip -q sdk-tools-linux-3859397.zip && \
    mv tools /opt/android/android-sdk
    
#    rm sdk-tools-linux-3859397.zip

# Install Android ndk
RUN wget https://dl.google.com/android/repository/android-ndk-r19c-linux-x86_64.zip && \
    unzip -q android-ndk-r19c-linux-x86_64.zip && \
    mv android-ndk-r19c /opt/android/android-ndk

#   rm android-ndk-r19c-linux-x86_64.zip

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

COPY build.sh /build.sh

ENTRYPOINT /bin/bash /build.sh

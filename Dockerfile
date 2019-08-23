FROM ubuntu:bionic
MAINTAINER Guenter Schwann version: 0.1

RUN apt-get update && apt-get clean
RUN apt-get install -y build-essential git zip unzip bzip2 p7zip wget curl chrpath

# Dependencies to create Android pkg
RUN apt-get install -y openjdk-8-jre openjdk-8-jdk openjdk-8-jdk-headless gradle

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

# Install Android SDK
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses && $ANDROID_HOME/tools/bin/sdkmanager --update
RUN $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-17"
RUN $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-28"
RUN $ANDROID_HOME/tools/bin/sdkmanager "build-tools;28.0.3"

# Download / install Qt
COPY qt_installer.qs /tmp
COPY download_android_qt.sh ./
RUN ./download_android_qt.sh

# Clean apt cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

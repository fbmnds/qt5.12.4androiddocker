FROM qt5-android17:latest


ENV DEBIAN_FRONTEND=noninteractive

# Add Android tools and platform tools to PATH
ENV ANDROID_HOME /opt/android/android-sdk
ENV ANDROID_SDK_ROOT /opt/android/android-sdk
ENV ANDROID_NDK_ROOT /opt/android/android-ndk
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

ENV ANDROID_NDK_HOST linux-x86_64

# Set the QTDIR environment variable
ENV QTDIR="/opt/Qt/5.12.6/android_armv7"

# Add ECL
RUN apt-get update && \
    apt-get install -y m4 && \
    cd /root && \
    git clone https://gitlab.com/embeddable-common-lisp/ecl.git && \
    cd ecl && \
    git checkout 0cc0fd914a8a18f64e5f1ee5d29e9479d394be39 && \
    ./configure && \
    make && \
    make install && \
    rm -rf /root/ecl

# Add cross-compiled ECL
COPY ecl-android.tar.gz /root
RUN cd /root && \
    tar -xf ecl-android.tar.gz


COPY build.sh /build.sh

ENTRYPOINT /bin/bash /build.sh

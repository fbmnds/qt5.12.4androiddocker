
mkdir -p ~/.cache/common-lisp/
curl -O https://beta.quicklisp.org/quicklisp.lisp
ecl --load quicklisp.lisp
## ... eval setup

cd
git clone https://gitlab.com/embeddable-common-lisp/ecl.git
mv ecl android
mkdir ecl
mv android ecl
cd ecl/android
git clone https://gitlab.com/embeddable-common-lisp/ecl.git
mv ecl 32bit

cd ~/ecl/android
cp ~/control-ui-lqml/lqml/platforms/android/build-ecl/*.sh .

cd ~/ecl/android/32bit
cp ~/control-ui-lqml/lqml/platforms/android/build-ecl/32bit/*.sh .


ln -s /opt/android/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/bin/clang /usr/bin
./1-make-ecl-host.sh

export ANDROID_NDK_ROOT=/opt/android/android-ndk
export ANDROID_NDK_TOOLCHAIN=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64

./2-make-ecl-android.sh

cd 32bit
cp ~/control-ui-lqml/lqml/platforms/android/build-ecl/32bit/*.sh .

# 32bit
apt-get install gcc-multilib

export ECL_ANDROID=/root/ecl/android/ecl-android
export ECL_ANDROID_32=/root/ecl/android/32bit/ecl-android


# build app
cd ~/control-ui-lqml/lqml/apps/control-ui/build-android
make clean && /opt/Qt/5.12.6/android_armv7/bin/qmake  "CONFIG+=32bit" ..
make clean && make install INSTALL_ROOT=/root/control-ui-lqml/lqml/apps/control-ui/build-android/android-build/
/opt/Qt/5.12.4/android_armv7/bin/androiddeployqt --input android-libapp.so-deployment-settings.json \
  --output android-build --android-platform android-17 --jdk $JAVA_HOME --gradle

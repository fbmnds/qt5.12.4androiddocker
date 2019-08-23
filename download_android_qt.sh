#!/bin/bash

set -ev

# Use the Qt online installer - it savely installs several Qt version
# But it uses a lot more disk space

export QT_QPA_PLATFORM=minimal
QT=qt-unified-linux-x64-online.run
curl -sL --retry 10 --retry-delay 10 -o /tmp/$QT https://download.qt.io/official_releases/online_installers/$QT
chmod +x /tmp/$QT
/tmp/$QT -v --script /tmp/qt_installer.qs LINUX=true
rm -f /tmp/$QT

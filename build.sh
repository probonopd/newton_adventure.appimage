#!/bin/sh
echo "Download bundable opendjk"
wget -c https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk11u-2019-10-31-00-22/OpenJDK11U-jdk_x64_linux_hotspot_2019-10-31-00-22.tar.gz
tar xf OpenJDK11U-jdk_x64_linux_hotspot_2019-10-31-00-22.tar.gz
mv jdk-11.0.5+9 jdk

echo "Download and build Newton Adventure"
git clone https://github.com/devnewton/jnuit.git jnuit
(cd jnuit; mvn install)
git clone https://github.com/devnewton/newton_adventure.git newton_adventure
(cd newton_adventure; mvn package)
cp newton_adventure/game/lwjgl/target/newton-adventure-lwjgl-1.17-SNAPSHOT.jar NewtonAdventure.AppDir/newton-adventure.jar

echo "Build custom jdk"
NEWTON_ADVENTURE_DEPS=`./jdk-11.0.5+9/bin/jdeps --print-module-deps NewtonAdventure.AppDir/newton-adventure.jar`
./jdk-11.0.5+9/bin/jlink --no-header-files --no-man-pages --compress=2 --strip-debug --add-modules $NEWTON_ADVENTURE_DEPS --output NewtonAdventure.AppDir/usr

wget -c https://github.com/AppImage/AppImageKit/releases/download/12/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage
ARCH=x86_64 ./appimagetool-x86_64.AppImage NewtonAdventure.AppDir/

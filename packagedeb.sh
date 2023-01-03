#!/bin/bash


PACKAGE_NAME="downloadaccelerator"
PACKAGE_VERSION="3.1"
SOURCE_DIR=$PWD
TEMP_DIR="/tmp"


#################################################
########### creation of debian package ##########
#################################################
 
mkdir -p $TEMP_DIR/debian/DEBIAN
mkdir -p $TEMP_DIR/debian/lib
mkdir -p $TEMP_DIR/debian/etc/xdg/autostart
mkdir -p $TEMP_DIR/debian/usr/bin
mkdir -p $TEMP_DIR/debian/usr/share/applications
mkdir -p $TEMP_DIR/debian/usr/share/$PACKAGE_NAME
mkdir -p $TEMP_DIR/debian/usr/share/doc/$PACKAGE_NAME
mkdir -p $TEMP_DIR/debian/usr/share/common-licenses/$PACKAGE_NAME
 
echo "Package: $PACKAGE_NAME" > $TEMP_DIR/debian/DEBIAN/control
echo "Version: $PACKAGE_VERSION" >> $TEMP_DIR/debian/DEBIAN/control
cat control >> $TEMP_DIR/debian/DEBIAN/control

#echo "#!/bin/sh" > $TEMP_DIR/debian/DEBIAN/postinst
#echo "setsid gnome-session --autostart=/usr/xdg/autostart &" >> $TEMP_DIR/debian/DEBIAN/postinst
#chmod +x $TEMP_DIR/debian/DEBIAN/postinst

cp $PACKAGE_NAME.desktop $TEMP_DIR/debian/usr/share/applications/
cp $PACKAGE_NAME"server".desktop $TEMP_DIR/debian/etc/xdg/autostart/
cp copyright $TEMP_DIR/debian/usr/share/common-licenses/$PACKAGE_NAME/ # results in no copyright warning
 
cp *.jar $TEMP_DIR/debian/usr/share/$PACKAGE_NAME/
cp $PACKAGE_NAME $TEMP_DIR/debian/usr/bin/
 
echo "$PACKAGE_NAME ($PACKAGE_VERSION) trusty; urgency=low" > changelog
echo "  * Rebuild" >> changelog
echo " -- Messey à Ndiomo <messey.bilal@gmail.com>  `date -R`" >> changelog
gzip -9c changelog > $TEMP_DIR/debian/usr/share/doc/$PACKAGE_NAME/changelog.gz
 
cp *.png $TEMP_DIR/debian/usr/share/$PACKAGE_NAME/

cp -r images $TEMP_DIR/debian/usr/share/$PACKAGE_NAME/

 
PACKAGE_SIZE=`du -bs $TEMP_DIR/debian | cut -f 1`
PACKAGE_SIZE=$((PACKAGE_SIZE/1024))
echo "Installed-Size: $PACKAGE_SIZE" >> $TEMP_DIR/debian/DEBIAN/control
 
 
cd $TEMP_DIR/
dpkg --build debian
mv debian.deb $SOURCE_DIR/$PACKAGE_NAME-$PACKAGE_VERSION.deb
rm -r $TEMP_DIR/debian

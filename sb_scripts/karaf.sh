##############
# Apache Karaf
##############

echo "Installing Apache Karaf"

SHARED_DIR=$1

if [ -f "$SHARED_DIR/sb_scripts/config" ]; then
  . $SHARED_DIR/sb_scripts/config
fi

cd $HOME_DIR

if [ ! -f "$DOWNLOAD_DIR/apache-karaf-$KARAF_VERSION.tar.gz" ]; then
  echo -n "Downloading Apache Karaf..."
  wget -q -O "$DOWNLOAD_DIR/apache-karaf-$KARAF_VERSION.tar.gz" "http://mirror.csclub.uwaterloo.ca/apache/karaf/"$KARAF_VERSION"/apache-karaf-"$KARAF_VERSION".tar.gz"
  echo " done"
fi

if [ ! -d "$KARAF_DIR/apache-karaf-$KARAF_VERSION" ]; then
    if [ ! -d "$HOME_DIR/apache-karaf-$KARAF_VERSION" ]; then
        echo -n "Extracting Apache Karaf..."
        tar zxf "$DOWNLOAD_DIR/apache-karaf-$KARAF_VERSION.tar.gz"
        echo " done"
    fi
    if [ ! -d "$KARAF_DIR/apache-karaf-$KARAF_VERSION" ]; then
        echo "Deploying Apache Karaf... "
        mv "$HOME_DIR/apache-karaf-$KARAF_VERSION" $KARAF_DIR
        echo " done"
    fi
fi

if [ -L "$KARAF_DIR/karaf" ]; then
    rm $KARAF_DIR/karaf
fi
echo "Symlinking Apache Karaf... "
ln -s "$KARAF_DIR/apache-karaf-$KARAF_VERSION" $KARAF_DIR/karaf
echo " done"

if [ ! -L "/etc/init.d/karaf-service" ]; then
    [[ -n "$SERVICED" ]] && echo "Installing Karaf as a service... "
    [[ -n "$SERVICED" ]] || echo "Installing Karaf... "
    # Run a setup script to add some feature repos and prepare it for running as a service
    $KARAF_DIR/karaf/bin/start
    sleep 60
    $KARAF_DIR/karaf/bin/client < $SHARED_DIR/sb_scripts/karaf_service.script
    $KARAF_DIR/karaf/bin/stop

    # Add it as a Linux service
    [[ -n "$SERVICED" ]] && ln -s $KARAF_DIR/karaf/bin/karaf-service /etc/init.d/
    [[ -n "$SERVICED" ]] && update-rc.d karaf-service defaults
    echo " done"
fi

# Add the vagrant user's maven repository
if ! grep -q "$HOME_DIR/.m2/repository" $KARAF_DIR/karaf/etc/org.ops4j.pax.url.mvn.cfg ; then
    echo "Adding  user's Maven repository... "
    sed -i "s|#org.ops4j.pax.url.mvn.localRepository=|org.ops4j.pax.url.mvn.localRepository=$HOME_DIR/.m2/repository|" $KARAF_DIR/karaf/etc/org.ops4j.pax.url.mvn.cfg
    echo " done"
fi

# Start it
[[ -n "$SERVICED" ]] && echo "Starting Karaf as a service... "
[[ -n "$SERVICED" ]] && service karaf-service start
[[ -n "$SERVICED" ]] || echo "Starting Karaf... "
[[ -n "$SERVICED" ]] || $KARAF_DIR/karaf/bin/start
sleep 60
echo " done"

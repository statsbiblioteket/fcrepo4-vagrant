
echo "Installing Solr"

SHARED_DIR=$1

if [ -f "$SHARED_DIR/sb_scripts/config" ]; then
  . $SHARED_DIR/sb_scripts/config
fi

if [ ! -d $SOLR_HOME ]; then
  mkdir -p $SOLR_HOME
fi

if [ ! -f "$DOWNLOAD_DIR/solr-$SOLR_VERSION.tgz" ]; then
  echo -n "Downloading Solr..."
  wget -q -O "$DOWNLOAD_DIR/solr-$SOLR_VERSION.tgz" "http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz"
  echo " done"
fi

cd /tmp
cp "$DOWNLOAD_DIR/solr-$SOLR_VERSION.tgz" /tmp
echo "Extracting Solr"
tar -xzf solr-"$SOLR_VERSION".tgz
cp -v /tmp/solr-"$SOLR_VERSION"/dist/solr-"$SOLR_VERSION".war $WEBAPPS_DIR/solr.war
chown $TOMCAT_USER:$TOMCAT_GROUP $WEBAPPS_DIR/solr.war

if [ ! -f "$DOWNLOAD_DIR/commons-logging-1.1.2.jar" ]; then
  echo -n "Downloading commons-logging..."
  wget -q -O "$DOWNLOAD_DIR/commons-logging-1.1.2.jar" "http://repo1.maven.org/maven2/commons-logging/commons-logging/1.1.2/commons-logging-1.1.2.jar"
  echo " done"
fi

cp "$DOWNLOAD_DIR/commons-logging-1.1.2.jar" $TOMCAT_LIBS

cp /tmp/solr-"$SOLR_VERSION"/example/lib/ext/slf4j* $TOMCAT_LIBS
cp /tmp/solr-"$SOLR_VERSION"/example/lib/ext/log4j* $TOMCAT_LIBS

chown -hR $TOMCAT_USER:$TOMCAT_GROUP $TOMCAT_LIBS

cp -Rv /tmp/solr-"$SOLR_VERSION"/example/solr/* $SOLR_HOME

cp $SHARED_DIR/config/schema.xml $SOLR_HOME/collection1/conf

chown -hR $TOMCAT_USER:$TOMCAT_GROUP $SOLR_HOME

#touch $TOMCAT_LOGS/velocity.log
#chown $TOMCAT_USER:$TOMCAT_GROUP $TOMCAT_LOGS/velocity.log

eval $TOMCAT_RESTART

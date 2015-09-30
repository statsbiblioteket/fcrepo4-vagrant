###
# TOMCAT 7
###

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

# Tomcat
apt-get -y install tomcat8 tomcat8-admin
usermod -a -G $TOMCAT_GROUP vagrant

if ! grep -q "role rolename=\"fedoraAdmin\"" $TOMCAT_CONF/tomcat-users.xml ; then
  sed -i '$i<role rolename="fedoraUser"/>
  $i<role rolename="fedoraAdmin"/>
  $i<role rolename="manager-gui"/>
  $i<user username="testuser" password="password1" roles="fedoraUser"/>
  $i<user username="adminuser" password="password2" roles="fedoraUser"/>
  $i<user username="fedoraAdmin" password="secret3" roles="fedoraAdmin"/>
  $i<user username="fedora4" password="fedora4" roles="manager-gui"/>' $TOMCAT_CONF/tomcat-users.xml
fi

if ! grep -q "$JAVA8_HOME" $TOMCAT_ENV ; then
  echo "JAVA_HOME=$JAVA8_HOME" >> $TOMCAT_ENV
fi

# Make the ingest directory
mkdir -p /mnt/ingest
chown -R $TOMCAT_USER:$TOMCAT_GROUP /mnt/ingest


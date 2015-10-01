###
# TOMCAT 7
###

SHARED_DIR=$1

if [ -f "$SHARED_DIR/sb_scripts/config" ]; then
  source $SHARED_DIR/sb_scripts/config
fi

# Tomcat
#yum -y install tomcat tomcat-admin-webapps
#usermod -a -G $TOMCAT_GROUP vagrant
if [ ! -f  $TOMCAT_CONF/tomcat-users.xml ]; then
  echo '<tomcat-users xmlns="http://tomcat.apache.org/xml" version="1.0">' >> $TOMCAT_CONF/tomcat-users.xml
  echo '</tomcat-users>' >> $TOMCAT_CONF/tomcat-users.xml
fi

if ! grep -q "role rolename=\"fedoraAdmin\"" $TOMCAT_CONF/tomcat-users.xml ; then
  sed -i '$i<role rolename="fedoraUser"/>
  $i<role rolename="fedoraAdmin"/>
  $i<role rolename="manager-gui"/>
  $i<user username="testuser" password="password1" roles="fedoraUser"/>
  $i<user username="adminuser" password="password2" roles="fedoraUser"/>
  $i<user username="fedoraAdmin" password="secret3" roles="fedoraAdmin"/>
  $i<user username="fedora4" password="fedora4" roles="manager-gui"/>' $TOMCAT_CONF/tomcat-users.xml
fi

if [ ! -f  $TOMCAT_ENV ]; then
  touch $TOMCAT_ENV
fi

if ! grep -q "$JAVA8_HOME" $TOMCAT_ENV ; then
  echo "export JAVA_HOME=$JAVA8_HOME" >> $TOMCAT_ENV
fi

# Make the ingest directory
mkdir -p $SHARED_DIR/ingest
chown -R $TOMCAT_USER:$TOMCAT_GROUP $SHARED_DIR/ingest


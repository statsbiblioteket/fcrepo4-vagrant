###
# Java
###

SHARED_DIR=$1

if [ -f "$SHARED_DIR/sb_scripts/config" ]; then
  . $SHARED_DIR/sb_scripts/config
fi

# Java
if which java >/dev/null; then
  echo "skip java 8 installation"
else
  echo "java 8 installation"
  yum -y install java-1.8.0-openjdk-devel.x86_64
fi

# Maven
yum -y install maven


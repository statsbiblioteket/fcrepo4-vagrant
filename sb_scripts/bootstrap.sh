###
# BASICS
###

SHARED_DIR=$1

if [ -f "$SHARED_DIR/sb_scripts/config" ]; then
  . $SHARED_DIR/sb_scripts/config
fi

cd $HOME_DIR

# Update
#apt-get -y update && apt-get -y upgrade

# SSH
#apt-get -y install openssh-server

# Build tools
#apt-get -y install build-essential

sudo yum -y install curl wget maven


# More helpful packages
sudo yum -y install tree psmisc

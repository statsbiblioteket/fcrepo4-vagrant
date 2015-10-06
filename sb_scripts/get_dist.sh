
set -x
cd $(dirname $(readlink -f $0))
echo $PWD

if [ ! -r config ];
then 
	echo "No configuration found"
	exit 1
fi
source config

mkdir -p $DIST_DIR
cd $DIST_DIR

# Get Karaf container
curl -s -L -o "apache-karaf-$KARAF_VERSION.tar.gz" "http://mirror.csclub.uwaterloo.ca/apache/karaf/$KARAF_VERSION/apache-karaf-$KARAF_VERSION.tar.gz" 

# Get Fuseki
curl -s -L -o "apache-jena-fuseki-$FUSEKI_VERSION-distribution.tar.gz" "http://www.us.apache.org/dist/jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz"

# Get solr dist
curl -s -L -o "solr-$SOLR_VERSION.tgz" "http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz"

# Get Fedora 4
if [ "${FEDORA_AUTH}" = "true" ] && [ "${FEDORA_AUDIT}" = "true" ]; then
  FEDORA_WAR="fcrepo-webapp-plus-rbacl-audit-${FEDORA_VERSION}.war"
  RELEASES="https://github.com/fcrepo4-exts/fcrepo-webapp-plus/releases/download/fcrepo-webapp-plus-${FEDORA_TAG}"
elif [ "${FEDORA_AUTH}" = "true" ]; then
  FEDORA_WAR="fcrepo-webapp-plus-rbacl-${FEDORA_VERSION}.war"
  RELEASES="https://github.com/fcrepo4-exts/fcrepo-webapp-plus/releases/download/fcrepo-webapp-plus-${FEDORA_TAG}"
elif [ "${FEDORA_AUDIT}" = "true" ]; then
  FEDORA_WAR="fcrepo-webapp-plus-audit-${FEDORA_VERSION}.war"
  RELEASES="https://github.com/fcrepo4-exts/fcrepo-webapp-plus/releases/download/fcrepo-webapp-plus-${FEDORA_TAG}"
else 
  WEBAPP="fcrepo-webapp-${FEDORA_VERSION}.war"
  RELEASES="https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-${FEDORA_TAG}"
fi

rm fcrepo4.war
curl -L -s -o fcrepo4.war "$RELEASES/$FEDORA_WAR"

# Get camel apps
mkdir camel-apps
cd camel-apps
# go fetch
cd $DIST_DIR



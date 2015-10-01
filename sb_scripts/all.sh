SCRIPT_DIR=$(dirname $(readlink -f $0))

$SCRIPT_DIR/bootstrap.sh $HOME
$SCRIPT_DIR/java.sh $HOME
$SCRIPT_DIR/tomcat.sh $HOME
$SCRIPT_DIR/solr.sh $HOME
$SCRIPT_DIR/fedora4.sh $HOME
$SCRIPT_DIR/fuseki.sh $HOME
$SCRIPT_DIR/karaf.sh $HOME
$SCRIPT_DIR/fedora_camel_toolbox.sh $HOME
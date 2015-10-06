#!/bin/bash

set -x
cd $(dirname $(readlink -f $0))
echo $PWD

if [ ! -r config ];
then
        echo "No configuration found"
        exit 1
fi
source config

mkdir -p $FUSEKI_DIR

cd $DIST_DIR
tar xf apache-jena-fuseki*
cd apache-jena-fuseki*
cp -r * $FUSEKI_DIR
cd $FUSEKI_DIR
cp fuseki.war $WEBAPPS_DIR

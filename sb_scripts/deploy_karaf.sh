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

mkdir -p $KARAF_DIR

cd $DIST_DIR
tar xf apache-karaf*
cd apache-karaf*
cp -r * $KARAF_DIR




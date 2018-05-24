#!/bin/bash -e

BASEDIR=$(dirname "$0")
JVM_MIN_HEAP=4G
JVM_MAX_HEAP=16G

echo "*** Running as user $(whoami) using basedir: $BASEDIR ..."
echo "*** Updating KernelHaven ..."
cd $BASEDIR

file="update-root.txt"
cat $file | egrep -v '^#' | xargs wget -N

echo "*** Updating Plugins ..."
cd plugins

file="../update-plugins.txt"
cat $file | egrep -v '^#' | xargs wget -N


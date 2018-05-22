#!/bin/sh -e

BASEDIR=$(dirname "$0")

cd $BASEDIR

cd diffs
cat diffs.z* > diffs-joined.zip
unzip diffs-joined.zip
rm diffs-joined.zip

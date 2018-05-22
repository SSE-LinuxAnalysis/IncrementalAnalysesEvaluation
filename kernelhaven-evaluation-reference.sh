#!/bin/sh -e

BASEDIR=$(dirname "$0")
JVM_MIN_HEAP=4G
JVM_MAX_HEAP=16G

echo "*** Running as user $(whoami) using basedir: $BASEDIR ..."
echo "*** Updating KernelHaven ..."
cd $BASEDIR

yes | cp -rf config/configuration-reference.properties configuration-reference.properties

for file in diffs/*.diff; do
    [ -e "$file" ] || continue
    filepath=$(realpath $file)
    cd source-code/linux
    echo "Applying diff: $filepath"
    git apply --no-index $filepath
    cd ../../
    echo "Running KernelHaven"
    exec java "-Xms${JVM_MIN_HEAP}" "-Xmx${JVM_MAX_HEAP}" -jar KernelHaven.jar configuration-reference.properties
done


exit 0

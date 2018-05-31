#!/bin/bash -e

BASEDIR=$(dirname "$0")
JVM_MIN_HEAP=10G
JVM_MAX_HEAP=50G

echo "*** Running as user $(whoami) using basedir: $BASEDIR ..."

cd $BASEDIR

test -d time/reference || mkdir -p time/reference

yes | cp -rf config/configuration-reference.properties configuration-reference.properties

for file in diffs/*.diff; do
    [ -e "$file" ] || continue
    # rename git directory to prevent issues with git apply
    if [ -d .git ]; then
        mv .git .git.backup
    fi

    # get the complete path to the diff-file
    filepath=$(realpath $file)
    cd source-code/linux
    echo "Applying diff: $filepath"
    git apply --no-index $filepath
    cd ../../

    # revert name changes to git directory
    if [ -d .git.backup ]; then
        mv .git.backup .git
    fi

    echo "*** Running KernelHaven..."
    touch ./time/reference/time-${file##*/}.log
    /usr/bin/time -v -o ./time/reference/time-${file##*/}.log java "-Xms${JVM_MIN_HEAP}" "-Xmx${JVM_MAX_HEAP}" -jar KernelHaven.jar configuration-reference.properties
done


exit 0

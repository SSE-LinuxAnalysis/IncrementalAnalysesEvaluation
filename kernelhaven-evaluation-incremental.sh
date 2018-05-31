#!/bin/bash -e

BASEDIR=$(dirname "$0")
JVM_MIN_HEAP=100G
JVM_MAX_HEAP=200G

echo "*** Running as user $(whoami) using basedir: $BASEDIR ..."
echo "*** Updating KernelHaven ..."
cd $BASEDIR

if [ -d .git ]; then
   mv .git .git.backup
fi

test -d time/incremental || mkdir -p time/incremental

for file in diffs/*.diff; do
    [ -e "$file" ] || continue
    echo "Running on file: $file"
    sed "s/$(echo DIFF_FILE_GENERATED_VALUE | sed -e 's/\([[\/.*]\|\]\)/\\&/g')/$(echo $file | sed -e 's/[\/&]/\\&/g')/g" config/configuration-incremental.properties > configuration-incremental.properties
    touch ./time/incremental/time-${file##*/}.log
    /usr/bin/time -v -o ./time/incremental/time-${file##*/}.log java "-Xms${JVM_MIN_HEAP}" "-Xmx${JVM_MAX_HEAP}" -jar KernelHaven.jar configuration-incremental.properties
done

if [ -d .git.backup ]; then
   mv .git.backup .git
fi

exit 0

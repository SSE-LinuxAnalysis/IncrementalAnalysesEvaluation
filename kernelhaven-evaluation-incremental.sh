#!/bin/sh -e

BASEDIR=$(dirname "$0")
JVM_MIN_HEAP=4G
JVM_MAX_HEAP=16G

echo "*** Running as user $(whoami) using basedir: $BASEDIR ..."
echo "*** Updating KernelHaven ..."
cd $BASEDIR

if [ -d .git ]; then
   mv .git .git.backup
fi


for file in diffs/*.diff; do
    [ -e "$file" ] || continue
    echo "Running on file: $file"
    sed "s/$(echo DIFF_FILE_GENERATED_VALUE | sed -e 's/\([[\/.*]\|\]\)/\\&/g')/$(echo $file | sed -e 's/[\/&]/\\&/g')/g" config/configuration-incremental.properties > configuration-incremental.properties
    exec java "-Xms${JVM_MIN_HEAP}" "-Xmx${JVM_MAX_HEAP}" -jar KernelHaven.jar configuration-incremental.properties
done

if [ -d .git.backup ]; then
   mv .git.backup .git
fi

exit 0

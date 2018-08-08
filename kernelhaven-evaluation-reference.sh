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

    # get the complete path to the diff-file
    filepath=$(realpath $file)
    
    if [ -s "$file" ]
    then
        # rename git directory to prevent issues with git apply
        if [ -d .git ]; then
            mv .git .git.backup
        fi 
        
        cd source-code/linux
        echo "Applying diff: $filepath"
        git apply --no-index --ignore-space-change --ignore-whitespace $filepath
        cd ../../

        # revert name changes to git directory
        if [ -d .git.backup ]; then
            mv .git.backup .git
        fi

        echo "*** Running KernelHaven..."
        touch ./time/reference/time-${file##*/}.log
        /usr/bin/time -v -o ./time/reference/time-${file##*/}.log java "-Xms${JVM_MIN_HEAP}" "-Xmx${JVM_MAX_HEAP}" -jar KernelHaven.jar configuration-reference.properties
    
        cd log/reference
        # get name of most recent log file that has not be renamed yet
        LOG_FILE=$(find -maxdepth 1 -name 'KernelHaven*' -printf "%T+\t%p\n" | sort | sed '{$!d}' | tail -c +32)
        if [ -n "$LOG_FILE" ]; then
            # rename the file
            mv "$LOG_FILE" log-${file##*/}.log
        fi
    
        cd ../../output/reference
        OUTPUT_FILE=$(find -maxdepth 1 -name 'Analysis*' -printf "%T+\t%p\n" | sort | sed '{$!d}' | tail -c +32)
        if [ -n "$OUTPUT_FILE" ]; then
            mv "$OUTPUT_FILE" output-${file##*/}.csv
        fi
        cd ../../
    else
        echo "File $file is empty. Skipping $file ..."
    fi
done


exit 0

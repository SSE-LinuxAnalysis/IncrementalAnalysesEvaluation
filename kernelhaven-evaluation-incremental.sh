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
    
    cd ./log/incremental
    # get name of most recent log file that has not be renamed yet
    LOG_FILE = $(find -maxdepth 1 -name 'KernelHaven*' -printf "%T+\t%p\n" | sort | sed '{$!d}' | tail -c +32)
    if [ -n "$LOG_FILE" ]; then
        # rename the file
        mv $LOG_FILE log-${file##*/}
    fi
    cd ${BASEDIR}
    
    cd ./output/incremental
    OUTPUT_FILE = $(find -maxdepth 1 -name 'Analysis*' -printf "%T+\t%p\n" | sort | sed '{$!d}' | tail -c +32)
    if [ -n "$OUTPUT_FILE" ]; then
        mv $OUTPUT_FILE output-${file##*/}
    fi
    cd ${BASEDIR} 
done

if [ -d .git.backup ]; then
   mv .git.backup .git
fi

exit 0

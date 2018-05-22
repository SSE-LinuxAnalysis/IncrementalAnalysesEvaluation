#!/bin/sh -e

BASEDIR=$(dirname "$0")

cd $BASEDIR


if [ -d .git.backup ]; then
   mv .git.backup .git
fi

rm -rf log
rm -rf output
rm -rf res
rm -rf source-code
rm -rf cache
rm -rf hybrid_cache
rm -rf archive

mkdir archive
mkdir archive/incremental
mkdir archive/reference
mkdir cache
mkdir hybrid_cache
mkdir log
mkdir log/incremental
mkdir log/reference
mkdir output
mkdir output/incremental
mkdir output/reference
mkdir res
mkdir source-code
mkdir source-code/linux


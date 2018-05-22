#!/bin/sh -e

BASEDIR=$(dirname "$0")

cd $BASEDIR

rm -rf log
rm -rf output
rm -rf res
rm -rf source-code
rm -rf cache
rm -rf hybrid_cache
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


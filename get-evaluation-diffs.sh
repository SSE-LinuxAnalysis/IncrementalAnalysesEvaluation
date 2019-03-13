#!/bin/sh -e

BASEDIR=$(dirname "$0")

cd $BASEDIR

mkdir -p diffs
cd diffs

wget https://github.com/moritzfl/IncrementalAnalysesEvaluation/releases/download/2.1/diffs.zip
unzip diffs.zip
rm diffs.zip

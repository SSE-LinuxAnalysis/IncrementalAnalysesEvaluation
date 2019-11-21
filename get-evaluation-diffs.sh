#!/bin/sh -e

BASEDIR=$(dirname "$0")

cd $BASEDIR

mkdir -p diffs
cd diffs

wget -O diffs.zip https://github.com/moritzfl/IncrementalAnalysesEvaluation/releases/download/4.0/diffs.zip
unzip diffs.zip
rm diffs.zip

#!/bin/bash

ROOT=/scratch/SixTrack
NAME=ScatterOne
EXEC=SixTrack.e

if [ -d $ROOT/ScatterOne ]; then
    mv -v $ROOT/ScatterOne $ROOT/ScatterOne.$(date +%Y%m%d-%H%M%S)
fi

CURR=$(pwd)
mkdir -pv $ROOT/$NAME
cd $ROOT/$NAME

cp $HOME/Code/SixTrack/$EXEC .


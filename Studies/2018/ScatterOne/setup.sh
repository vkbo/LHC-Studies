#!/bin/bash

# Settings
ROOT=/scratch/SixTrack
NAME=ScatterOne
SIXT=SixTrack.e
MADX=MadX.e
IPS=15

# ================================================================================================ #

echo "Preparing Simulation Folder"
echo "==========================="
SIMD=$ROOT/$NAME-$(date +%Y.%m.%d-%H.%M)
SIXR=$HOME/Code/SixTrack
MADR=$HOME/Code/MadX
CURR=$(pwd)

mkdir -pv $SIMD
mkdir -pv $SIMD/MadX
cd $SIMD

ln -s $SIXR/$SIXT $SIXT
ln -s $MADR/$MADX MadX/$MADX
ln -s $CURR/makeOptics.madx MadX/makeOptics.madx
echo ""

echo "Running MadX"
echo "============"
cd $SIMD/MadX
./$MADX makeOptics.madx > madx.log
tail -n3 madx.log
cat checkValues.txt
echo ""

echo "Prepare SixTrack Inputs"
echo "======================="
cd $SIMD
cp MadX/fc.2 ./fort.2
$CURR/setupFort2.py fort.2 $IPS
mv -v fort.2 fort.2.orig
mv -v fort.2.mod fort.2
cp -v $CURR/fort.3 fort.3
echo ""


#!/bin/bash

# Settings
ROOT=/scratch/SixTrack
NAME=ScatterOne
SIXT=SixTrackDev.e
COLL=SixTrackCollDev.e
MADX=MadX.e
IPS=15

# ================================================================================================ #
echo ""
echo "Preparing Simulation Folder"
echo "==========================="
SIMD=$ROOT/$NAME-$(date +%Y.%m.%d)
SIXR=$HOME/Code/SixTrack
MADR=$HOME/Code/MadX
CURR=$(pwd)

mkdir -pv $SIMD
mkdir -pv $SIMD/MadX
mkdir -pv $SIMD/ST.Coll
mkdir -pv $SIMD/ST.Norm

rm -rf $SIMD/MadX/*
rm -rf $SIMD/ST.Coll/*
rm -rf $SIMD/ST.Norm/*

cd $SIMD

ln -sf $SIXR/$COLL           ST.Coll/$COLL
ln -sf $SIXR/$SIXT           ST.Norm/$SIXT
ln -sf $MADR/$MADX           MadX/$MADX
ln -sf $CURR/makeOptics.madx MadX/makeOptics.madx
echo ""

echo "Running MadX"
echo "============"
cd $SIMD/MadX
./$MADX makeOptics.madx > madx.log
tail -n3 madx.log
cat checkValues.txt
echo ""

echo "Prepare SixTrack Inputs - Normal"
echo "================================"
cd $SIMD/ST.Norm
cp $SIMD/MadX/fc.2 ./fort.2
$CURR/setupFort2.py fort.2 $IPS
mv -v fort.2 fort.2.orig
mv -v fort.2.mod fort.2
cp -v $CURR/fort.3.norm fort.3
echo ""

echo "Prepare SixTrack Inputs - Collimation"
echo "====================================="
cd $SIMD/ST.Coll
cp $SIMD/MadX/fc.2 ./fort.2
$CURR/setupFort2.py fort.2 $IPS
mv -v fort.2 fort.2.orig
mv -v fort.2.mod fort.2
cp -v $CURR/fort.3.coll fort.3
cp -v $CURR/CollDB-HLLHC.dat CollDB-HLLHC.dat
echo ""


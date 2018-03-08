#!/bin/bash

# Settings
ROOT=/scratch/SixTrack
NAME=ScatterOne
SIXT=SixTrackDev.e
COLL=SixTrackCollDev.e
MADX=MadX.e

# Scatter in IP:
IPS=5

echo ""
echo "**************************************"
echo "* Setup Script for Scatter One Study *"
echo "**************************************"

# ================================================================================================ #
echo ""
echo "Preparing Simulation Folder"
echo "==========================="

if [ -z $1 ]; then
    echo "No project name specified ..."
    echo "Available projects are:"
    ls -lh $ROOT | grep $NAME
    echo ""
    echo " !! Exiting !!"
    echo ""
    exit 1
fi

SIMD=$ROOT/$NAME.$1
SIXR=$HOME/Code/SixTrack
MADR=$HOME/Code/MadX
APER=$SIXR/Analysis/Aperture
CURR=$(pwd)

if [ -d "$SIMD" ]; then
    if [ "$2" == "-r" ]; then
        rm -rfv $SIMD
    elif [ "$2" == "-m" ]; then
        mv -v $SIMD $SIMD.$(date +%Y.%m.%d)
    else
        echo "Folder already exists. Only symlinks will be updated."
        echo ""
    fi
fi

mkdir -pv $SIMD
mkdir -pv $SIMD/Aperture
mkdir -pv $SIMD/MadX
mkdir -pv $SIMD/ST.Coll
mkdir -pv $SIMD/ST.Norm

cd $SIMD

ln -svf $MADR/$MADX                   Aperture/$MADX
ln -svf $APER/makeOpticsHLLHC1.2.madx Aperture/makeOptics.madx
ln -svf $MADR/$MADX                   MadX/$MADX
ln -svf $CURR/makeOptics.madx         MadX/makeOptics.madx
ln -svf $SIXR/$COLL                   ST.Coll/$COLL
ln -svf $SIXR/$SIXT                   ST.Norm/$SIXT
echo ""

echo "Generating Aperture Files (MadX)"
echo "================================"
cd $SIMD/Aperture
./$MADX makeOptics.madx > madx.log
tail -n3 madx.log
cat checkValues.txt
ln -sfv $SIMD/Aperture/apertureHLLHC1.2/twiss_lhcb1_aperture.tfs $SIMD/ST.Coll/aperOne.tfs
ln -sfv $SIMD/Aperture/apertureHLLHC1.2/twiss_lhcb1_aperture.tfs $SIMD/ST.Norm/aperOne.tfs
echo ""

echo "Generating SixTrack Input Files (MadX)"
echo "======================================"
cd $SIMD/MadX
./$MADX makeOptics.madx > madx.log
tail -n3 madx.log
cat checkValues.txt
echo ""

echo "Prepare SixTrack Inputs - Normal"
echo "================================"
cd $SIMD/ST.Norm
# Fort 2
cp $SIMD/MadX/fc.2 ./fort.2
$CURR/setupFort2.py fort.2 $IPS
mv -v fort.2 fort.2.orig
mv -v fort.2.mod fort.2
# Fort 3
cp -v $CURR/fort.3.norm fort.3
echo ""

echo "Prepare SixTrack Inputs - Collimation"
echo "====================================="
cd $SIMD/ST.Coll
# Fort 2
cp $SIMD/MadX/fc.2 ./fort.2
$CURR/setupFort2.py fort.2 $IPS
mv -v fort.2 fort.2.orig
mv -v fort.2.mod fort.2
# Fort 3
cp -v $CURR/fort.3.coll fort.3
$CURR/setupFort3.py aperOne.tfs fort.3 $IPS
mv -v fort.3 fort.3.orig
mv -v fort.3.mod fort.3
# Collimation
cp -v $CURR/CollDB-HLLHC.dat CollDB-HLLHC.dat
# head -n -1 fort.3 > fort.3.tmp
# cat $SIMD/MadX/fc.3.aper >> fort.3.tmp
# echo "ENDE" >> fort.3.tmp
# rm -v fort.3
# mv -v fort.3.tmp fort.3
echo ""


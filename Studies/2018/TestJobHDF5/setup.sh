#!/bin/bash

# Arguments
# $1 Name
# $2 Flag
#    -r : Delete previous data
#    -m : Backup previous data

# Settings
ROOT=/scratch/SixTrack
NAME=TestJobHDF5
SIXT=SixTrackPythiaH5Dev.e
MADX=MadX.e

# Simulation Settings
IPS=5
TMIN=1.4

echo ""
echo "**************************************"
echo "* Setup Script for Test Job for HDF5 *"
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
APER=$HOME/Code/LHC-Studies/Aperture
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
mkdir -pv $SIMD/ST.Job

cd $SIMD

ln -svf $MADR/$MADX                   Aperture/$MADX
ln -svf $APER/makeOpticsHLLHC1.2.madx Aperture/makeOptics.madx
ln -svf $MADR/$MADX                   MadX/$MADX
ln -svf $CURR/makeOptics.madx         MadX/makeOptics.madx
ln -svf $SIXR/$SIXT                   ST.Job/$SIXT
ln -svf $CURR/genParticles.py         ST.Job/genParticles.py
echo ""

echo "Generating Aperture Files (MadX)"
echo "================================"
cd $SIMD/Aperture
./$MADX makeOptics.madx > madx.log
tail -n3 madx.log
cat checkValues.txt
ln -sfv $SIMD/Aperture/apertureHLLHC1.2/twiss_lhcb1_aperture.tfs $SIMD/ST.Job/aperOne.tfs
echo ""

echo "Generating SixTrack Input Files (MadX)"
echo "======================================"
cd $SIMD/MadX
./$MADX makeOptics.madx > madx.log
tail -n3 madx.log
cat checkValues.txt
echo ""

echo "Prepare SixTrack Inputs"
echo "======================="
cd $SIMD/ST.Job
# Fort 2
cp $SIMD/MadX/fc.2 fort.2
$CURR/setupFort2.py fort.2 $IPS
mv -v fort.2 fort.2.orig
mv -v fort.2.mod fort.2
# Fort 3
cp -v $CURR/fort.3.template fort.3
cp -v $SIMD/MadX/fc.3.aper limi.dat
$CURR/setupFort3.py $IPS $TMIN
mv -v fort.3 fort.3.orig
mv -v fort.3.mod fort.3
# Collimation
cp -v $CURR/CollDB-HLLHC.dat CollDB-HLLHC.dat
echo ""


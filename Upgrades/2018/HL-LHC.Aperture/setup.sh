#!/bin/bash

# Settings
ROOT=/scratch/MadX
NAME=HL-LHC.Aperture
MADX=MadX.e

read -p "Optics version [1.2]: " VERS
if [ -z $VERS ]; then
    VERS="1.2"
fi

echo ""
echo "**************************************"
echo "* Setup Script for HL-LHC Optics Fix *"
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

if [ -d "$SIMD" ]; then
    if [ "$2" == "-r" ]; then
        rm -rfv $SIMD
    else
        echo "Folder already exists. Only symlinks will be updated."
        echo ""
    fi
else
    mv -v $SIMD $SIMD.$(date +%Y.%m.%d)
fi

SIXR=$HOME/Code/SixTrack
MADR=$HOME/Code/MadX
CURR=$(pwd)

mkdir -pv $SIMD
cd $SIMD

ln -svf  $MADR/$MADX                            $MADX
ln -svf  $CURR/makeOptics.madx                  makeOptics.madx
ln -svnf /afs/cern.ch/eng/lhc/optics/runII/2015 db5
ln -svnf $HOME/Code/LHC-Optics/HL-LHCv$VERS     slhc
echo ""

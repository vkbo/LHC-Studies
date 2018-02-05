#!/bin/bash

# Settings
ROOT=/scratch/MadX
NAME=HL-LHC.Optics
MADX=MadX.e

echo ""
echo "Setup Script for HL-LHC Optics Fix"
echo "=================================="

# ================================================================================================ #
echo ""
echo "Preparing Simulation Folder"
echo "==========================="

if [ -z $1 ]; then
    echo "No project name specified ..."
    echo "Available projects are:"
    ls -lh $ROOT/$NAME*
    exit 1
fi
SIMD=$ROOT/$NAME.$1

if [ -d "$SIMD" ]; then
    if [ "$2" == "-r" ]; then
        rm -rfv $SIMD
    else
        echo "Folder already exists. Only symlinks will be updated."
    fi
else
    mv -v $SIMD $SIMD.$(date +%Y.%m.%d)
fi

SIXR=$HOME/Code/SixTrack
MADR=$HOME/Code/MadX
CURR=$(pwd)

mkdir -pv $SIMD
cd $SIMD

ln -sf $MADR/$MADX                            $MADX
ln -sf $CURR/makeOptics.madx                  makeOptics.madx
ln -sf $CURR/align_sepdip.madx                align_sepdip.madx
ln -sf /afs/cern.ch/eng/lhc/optics/runII/2015 db5
ln -sf $HOME/Code/LHC-Optics/HL-LHCv1.3       slhc
echo ""

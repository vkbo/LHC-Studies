#!/bin/bash

set -e

SDIR=$HOME/Code/LHC-Studies
RDIR=/scratch/SixTrack/Scatter
WDIR=Scatter.HL14.Init

cd $RDIR
echo "Entering folder $RDIR"
if [ -d "$WDIR" ]; then
    if [ "$1" != "-x" ]; then
        echo "Work folder $WDIR already exists, deleting ..."
        rm -rf $WDIR
        mkdir $WDIR
    fi
else
    mkdir $WDIR
fi
cd $WDIR

if [ ! -e madx-linux64-gnu ]; then
    wget http://madx.web.cern.ch/madx/releases/5.04.02/madx-linux64-gnu
fi
chmod +x madx-linux64-gnu

ln -fvns $SDIR/Optics/LHC2015  db5
ln -fvns $SDIR/Optics/HLLHC1.4 slhc

rm *.madx
cp -v $SDIR/Scatter/MadX/HL-LHC-1.4-v1/*.madx .

./madx-linux64-gnu makeOptics-30m.madx
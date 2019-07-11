#!/bin/bash

set -e

CDIR=$(pwd)
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
    wget http://madx.web.cern.ch/madx/releases/5.05.01/madx-linux64-gnu
fi
chmod +x madx-linux64-gnu

ln -fvns $SDIR/Optics/LHC2015  db5
ln -fvns $SDIR/Optics/HLLHC1.4 slhc

rm -f *.madx
ln -sfv $SDIR/Aperture/makeOpticsHLLHC1.4-Offset.madx makeOpticsHLLHC1.4-Offset.madx
ln -sfv $SDIR/Aperture/aperOffset.madx                aperOffset.madx
ln -sfv $CDIR/sliceMe.madx                            sliceMe.madx
ln -sfv $CDIR/prepInput.py                            prepInput.py

./madx-linux64-gnu makeOpticsHLLHC1.4-Offset.madx
./prepInput.py

cp fc.3.aper              aperLimi.dat
cp $CDIR/CollDB-HLLHC.dat CollDB-HLLHC.dat

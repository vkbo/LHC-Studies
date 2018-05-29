#!/bin/bash

# Settings
ROOT=/scratch/SixTrack
NAME=ScatterTwo
SIXT=SixTrackH5Dev.e
COLL=SixTrackCollH5Dev.e

# Folders
SIMD=$ROOT/$NAME.$1
OUTD=$SIMD/Output
RESD=$OUTD/Results.$2
CURR=$(pwd)
mkdir -pv $OUTD
mkdir -pv $RESD

cd $SIMD/ST.Coll
rm -fv seed.dat
rm -fv fort.6

for ((i=1; i<=$3; i++)); do
    echo ""
    echo "**************************"
    echo "  Running job $i of $3"
    echo "**************************"
    echo ""
    echo "Preparing Simulation ..."
    SAMP=$(printf %06d $i)
    
    # Generate Particles
    ./genParticles.py ./seed.dat ./
    
    # Set up fort.3
    cp SixIn/* ./
    SEEDA=$(date +%s)
    SEEDB=$(($SEEDA + 1))
    sed -i "s/%SEED1%/$SEEDA/g" fort.3
    sed -i "s/%SEED2%/$SEEDB/g" fort.3
    
    # Run it!
    echo "Running SixTrack ..."
    ./$COLL > fort.6
    
    # Save the stuff we care about
    echo "Copying Files ..."
    tar -czf fort.tar.gz fort.3 fort.6
    mv data.hdf5        $RESD/data.$SAMP.hdf5
    mv fort.tar.gz      $RESD/fort.$SAMP.tar.gz
    
    # Clean up that mess
    echo "Clean-up ..."
    rm fort.*
    rm *.dat
    echo "Done!"
done

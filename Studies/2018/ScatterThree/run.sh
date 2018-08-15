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
TDIR=$SIMD/RunTemp
CURR=$(pwd)
mkdir -pv $OUTD
mkdir -pv $RESD
mkdir -pv $TDIR

cd $TDIR
if [ -z $4 ]; then
    ST=1
else
    ST=$4
fi
for ((i=$ST; i<=$3; i++)); do
    echo ""
    echo "**************************"
    echo "  Running job $i of $3"
    echo "**************************"
    echo ""
    echo "Preparing Simulation ..."
    SAMP=$(printf %06d $i)
    RDIR=Run.Coll.$SAMP
    rm -rfv $RDIR
    mkdir -pv $RDIR
    cd $RDIR

    # Generate Particles
    $SIMD/ST.Coll/genParticles.py ./seed.dat ./

    # Set up fort.3
    cp $SIMD/ST.Coll/* ./
    SEED1=$(((10 * $i) + 1))
    SEED2=$(((10 * $i) + 2))
    SEED3=$(((10 * $i) + 3))
    LNOPT="WRITE OPTICS"
    sed -i "s/%SEED1%/$SEED1/g" fort.3
    sed -i "s/%SEED2%/$SEED2/g" fort.3
    sed -i "s/%SEED3%/$SEED3/g" fort.3
    if [ "$i" -eq "1" ]; then
        sed -i "s/%H5FLAGS%/$LNOPT/g" fort.3
    else
        sed -i "s/%H5FLAGS%//g" fort.3
    fi

    # Run it!
    echo "Running SixTrack ..."
    ./$COLL &> fort.6

    # Save the stuff we care about
    echo "Copying Files ..."
    tar -czf fort.tar.gz fort.3 fort.6 partDist.dat
    mv data.hdf5        $RESD/data.$SAMP.hdf5
    mv fort.tar.gz      $RESD/fort.$SAMP.tar.gz

    # Clean up that mess
    echo "Clean-up ..."
    cd $TDIR
    rm -rfv $RDIR
    echo "Done!"
done

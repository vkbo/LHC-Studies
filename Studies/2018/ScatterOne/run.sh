#!/bin/bash

# Settings
ROOT=/scratch/SixTrack
NAME=ScatterOne
SIXT=SixTrackDev.e
COLL=SixTrackCollDev.e

# Folders
SIMD=$ROOT/$NAME.$1
OUTD=$SIMD/Output
CURR=$(pwd)
mkdir -pv $OUTD

cd $SIMD/ST.Coll
rm -fv seed.dat
rm -fv fort.6

for ((i=1; i<=$3; i++)); do
    echo ""
    echo "**************************"
    echo "  Running job $i of $3"
    echo "**************************"
    echo ""
    RESD=$OUTD/Results.$2.$(printf %06d $i)
    mkdir -pv $RESD
    echo "Preparing Simulation ..."
    ./genParticles.py ./seed.dat ./
    cp fort.3 fort.3.bak
    SEEDA=$(date +%s)
    SEEDB=$(($SEEDA + 1))
    sed -i "s/SEED  42          43/SEED  $SEEDA  $SEEDB/g" fort.3
    echo "Running SixTrack ..."
    ./$COLL > fort.6
    echo "Copying Files ..."
    cp seed.dat         $RESD
    cp fort.2           $RESD
    mv fort.3           $RESD
    mv fort.6           $RESD
    mv fort.999         $RESD
    mv coll_summary.dat $RESD
    mv collgaps.dat     $RESD
    mv Coll_Scatter.dat $RESD
    mv scatter_log.txt  $RESD
    mv FirstImpacts.dat $RESD
    mv dump_*.txt       $RESD
    mv dist0.dat        $RESD
    mv distn.dat        $RESD
    mv survival.dat     $RESD
    mv symplect*.txt    $RESD
    cp fort.3.bak fort.3
    echo "Clean-up ..."
    rm fort.4
    rm fort.7
    rm fort.8
    rm fort.9
    rm fort.1[0123456789]
    rm fort.2[0123456789]
    rm fort.3[0123456789]
    rm fort.45
    rm fort.98
    rm fort.110
    rm fort.111
    rm beta*.dat
    rm all_*.dat
    rm ampl*.dat
    rm coll*.dat
    rm distsec
    rm dynksets.dat
    rm impact.dat
    rm orbitchecking.dat
    rm singletrackfile.dat
    rm effi*.dat
    rm FLUK*.dat
    rm *.out
    rm *.db
    echo "Done!"
done

#!/bin/bash

RDIR=/scratch/Testing
TDIR=testMasterVsDev
ODIR=$RDIR/$TDIR/$(date +%Y%m%d-%H%M%S)-Results
MDIR=$RDIR/$TDIR/Master
DDIR=$RDIR/$TDIR/Dev
CDIR=SixTrack/SixTrack_cmakesix_BUILD_TESTING_gfortran_release/SixTest

mkdir -pv $ODIR
mkdir -pv $MDIR
mkdir -pv $DDIR
echo ""

cd $MDIR
if [ -d "$MDIR" ]; then
    echo "Updating master branch ..."
    git checkout master
    git pull origin master
else
    echo "Downloading master branch ..."
    git clone git@github.com:SixTrack/SixTrack.git .
fi
git status
echo ""

if [ "$3" == "-nb" ]; then
    echo "Skipping build ..."
    echo ""
else
    echo "Building master branch ..."
    cd SixTrack
    ./cmake_six gfortran release BUILD_TESTING
    echo ""
fi

cd $DDIR
if [ -d "$MDIR" ]; then
    echo "Updating dev branch ..."
    git checkout dev
    git pull origin dev
else
    echo "Downloading dev branch ..."
    git clone git@github.com:SixTrack/SixTrack.git .
fi
git status
echo ""

if [ "$3" == "-nb" ]; then
    echo "Skipping build ..."
    echo ""
else
    echo "Building dev branch ..."
    cd SixTrack
    ./cmake_six gfortran release BUILD_TESTING
    echo ""
fi

touch $ODIR/master.summary.out
touch $ODIR/dev.summary.out

for ((i=1; i<=$2; i++)); do
    echo "Running tests - sample $i of $2 on master ..."
    cd $MDIR/$CDIR
    ctest $1 | tee $ODIR/master.$i.out
    tail -n1 $ODIR/master.$i.out >> $ODIR/master.summary.out
    echo ""

    echo "Running tests - sample $i of $2 on dev ..."
    cd $DDIR/$CDIR
    ctest $1 | tee $ODIR/dev.$i.out
    tail -n1 $ODIR/dev.$i.out >> $ODIR/dev.summary.out
    echo ""
done

echo "*****************************************************************"
echo ""
echo "Summary:"
echo ""
echo "ctest $1"
echo ""
echo "Master:"
cat $ODIR/master.summary.out
echo ""
echo "Dev:"
cat $ODIR/dev.summary.out
echo ""
echo "*****************************************************************"

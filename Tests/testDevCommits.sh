#!/bin/bash

RDIR=/scratch/Testing
TDIR=testDevCommits
ODIR=$RDIR/$TDIR/$(date +%Y%m%d-%H%M%S)-Results
DDIR=$RDIR/$TDIR/Dev
CDIR=SixTrack/SixTrack_cmakesix_BUILD_TESTING_gfortran_release/SixTest

mkdir -pv $ODIR
mkdir -pv $DDIR
echo ""

cd $DDIR
if [ -d "$DDIR/.git" ]; then
    echo "Updating dev branch ..."
    git checkout dev
    git pull origin dev
else
    echo "Downloading dev branch ..."
    git clone https://github.com:SixTrack/SixTrack.git .
fi
git status
echo ""

touch $ODIR/dev.summary.out

echo " Run  | Pass | Time         | Commit Hash" >> $ODIR/dev.summary.out
echo "------|------|--------------|-------------------------------------------------------------------------------------------------------" >> $ODIR/dev.summary.out
#for ((i=1; i<=$2; i++)); do
ITT=0
for COMMIT in $(git rev-list dev); do
    
    ITT=$((ITT+1))
    if [ $ITT -gt $2 ]; then
        break
    fi
    echo " Running $ITT of $2 ..."
    echo "************************************************************************************************************************************"
    echo ""
    echo "git checkout --detach $COMMIT"
    git checkout --detach $COMMIT
    echo ""
    
    OUTF=dev.$(printf %04d $ITT).out
    CMPF=dev.$(printf %04d $ITT).log
    
    cd $DDIR
    if [ "$3" == "-nb" ]; then
        echo "Skipping build ..."
        echo ""
    else
        echo "Building dev branch on commit $COMMIT ..."
        cd SixTrack
        ./cmake_six gfortran release BUILD_TESTING > $ODIR/$CMPF 2>&1
        echo "Done"
        echo ""
    fi
    
    if [ -d "$DDIR/$CDIR" ]; then
        cd $DDIR/$CDIR
        sleep 5
        ctest $1 | tee $ODIR/$OUTF
        TIME=$(tail -n20 $ODIR/$OUTF | grep "Test time")
        TIME=$(echo ${TIME:24} | tr -dc "0-9\.")
        PASS=$(tail -n20 $ODIR/$OUTF | grep "tests passed")
        PASS=$(echo ${PASS:0:4} | tr -dc "0-9")
        HASH=$(git rev-parse HEAD)
        CMSG=$(git log -1 --pretty=%B | head -n1)
        echo " $(printf %04d $ITT) | $(printf %3d $PASS)% | $(printf %8.2f $TIME) sec | $HASH > $CMSG" >> $ODIR/dev.summary.out
        echo ""
    else
        echo " Failed to compile ... " >> $ODIR/dev.summary.out
        echo "Failed to compile ... "
    fi
    echo ""
    echo "************************************************************************************************************************************"
    echo ""
done

echo " Summary for ctest $1"
echo "************************************************************************************************************************************"
echo ""
cat $ODIR/dev.summary.out | cut -c -132
echo ""
echo "************************************************************************************************************************************"
echo ""

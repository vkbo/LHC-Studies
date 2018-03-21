#!/bin/bash

RDIR=/scratch/Testing
TDIR=testDevCommits
PULL=dev
REPO=https://github.com/SixTrack/SixTrack.git
ODIR=$RDIR/$TDIR/$(date +%Y%m%d-%H%M%S)-Results
SDIR=$RDIR/$TDIR/Source
CDIR=SixTrack/SixTrack_cmakesix_BUILD_TESTING_gfortran_release/SixTest

mkdir -pv $ODIR
mkdir -pv $SDIR
echo ""

cd $SDIR
if [ -d "$SDIR/.git" ]; then
    echo "Updating $PULL branch ..."
    git remote update
    git checkout $PULL
    git pull origin $PULL
else
    echo "Downloading $PULL branch ..."
    git clone $REPO .
    git checkout $PULL
fi
git status
echo ""

touch $ODIR/summary.out

echo "" >> $ODIR/summary.out
echo "Command: ctest $1" >> $ODIR/summary.out
echo "" >> $ODIR/summary.out
echo " Run  | Pass | Total    | Fast     | Medium   | Commit Hash                              | Message" >> $ODIR/summary.out
echo "------|------|----------|----------|----------|------------------------------------------|----------------------------------------------" >> $ODIR/summary.out

ITT=0
for COMMIT in $(git rev-list $PULL); do
    
    ITT=$((ITT+1))
    if [ $ITT -gt $2 ]; then
        break
    fi
    if [ ! $(((($ITT-1))%$3)) == "0" ]; then
        echo "Skipping iteration $ITT"
        continue
    fi
    
    echo ""
    echo " Running $ITT of $2 ..."
    echo "****************************************************************************************************************************************"
    echo ""
    if [ "$4" == "-mrg" ] && [ "$ITT" -gt 1 ]; then
        echo "git reset --hard HEAD~1"
        git reset --hard HEAD~1
    else
        echo "git checkout --detach $COMMIT"
        git checkout --detach $COMMIT
    fi
    echo ""
    
    OUTF=$(printf %04d $ITT).out
    CMPF=$(printf %04d $ITT).log
    
    cd $SDIR
    if [ "$4" == "-nb" ]; then
        echo "Skipping build ..."
        echo ""
    else
        echo "Building $PULL branch on commit $COMMIT ..."
        cd SixTrack
        ./cmake_six gfortran release BUILD_TESTING > $ODIR/$CMPF 2>&1
        echo "Done"
        echo ""
    fi
    
    HASH=$(git rev-parse HEAD)
    CMSG=$(git log -1 --pretty=%B | head -n1)
    CUSR=$(git log -1 --format=%aN)
    CUSR=$(printf %-24s "$CUSR")
    echo "$HASH $CUSR : $CMSG" >> $ODIR/commits.out
    
    if [ -d "$SDIR/$CDIR" ]; then
        cd $SDIR/$CDIR
        sleep 5
        ctest $1 | tee $ODIR/$OUTF
        TIME=$(tail -n20 $ODIR/$OUTF | grep "Test time")
        TIME=$(echo ${TIME:24} | tr -dc "0-9\.")
        FAST=$(tail -n20 $ODIR/$OUTF | grep "fast")
        FAST=$(echo ${FAST:9:12} | tr -dc "0-9\.")
        MEDI=$(tail -n20 $ODIR/$OUTF | grep "medium")
        MEDI=$(echo ${MEDI:9:12} | tr -dc "0-9\.")
        PASS=$(tail -n20 $ODIR/$OUTF | grep "tests passed")
        PASS=$(echo ${PASS:0:4} | tr -dc "0-9")
        echo " $(printf %04d $ITT) | $(printf %3d $PASS)% | $(printf %8.2f $TIME) | $(printf %8.2f $FAST) | $(printf %8.2f $MEDI) | $HASH | $(echo $CMSG | cut -c -44)" >> $ODIR/summary.out
        echo ""
    else
        echo " Failed to compile ... " >> $ODIR/summary.out
        echo "Failed to compile ... "
    fi
    echo ""
    echo "****************************************************************************************************************************************"
    echo ""
done

echo ""
echo " Summary for ctest $1"
echo "****************************************************************************************************************************************"
echo ""
cat $ODIR/summary.out | cut -c -136
echo ""
echo "****************************************************************************************************************************************"
echo ""

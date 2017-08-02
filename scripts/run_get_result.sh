#!/bin/bash

#PBS -l select=1:ncpus=1:mem=5gb
#PBS -l pvmem=235gb
#PBS -l walltime=2:00:00
#PBS -l cput=2:00:00

LOG="$STDOUT_DIR/get_result.log"
ERRORLOG="$STDERR_DIR/get_result.log"

if [ ! -f "$LOG" ] ; then
	touch "$LOG"
fi

echo "Started `date`">>"$LOG"

echo "Host `hostname`">>"$LOG"

cd "$SAMPLE_DIR/blast"
export OUTPUTFILE="$SAMPLE_DIR/results_AMG.log"

find . -type f -name "results_*" -exec cat {} + >> $OUTPUTFILE 

echo "Finished `date`">>"$LOG"

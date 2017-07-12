#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=1:mem=5gb
#PBS -l pvmem=235gb
#PBS -l walltime=2:00:00
#PBS -l cput=2:00:00
#PBS -M aponsero@email.arizona.edu
#PBS -m bea

LOG="$STDOUT_DIR/split.log"
ERRORLOG="$STDERR_DIR/split.log"

if [ ! -f "$LOG" ] ; then
	touch "$LOG"
fi

echo "Started `date`">>"$LOG"

echo "Host `hostname`">>"$LOG"

#
# remove very short contigs (<500bp) and divide the file in managable chunks
#

module load perl

export RUN="$WORKER_DIR/divide_file.pl"
perl $RUN $SAMPLE $SPLIT 10000 2> "ERRORLOG"


echo "Finished `date`">>"$LOG"

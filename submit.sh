#!/bin/sh
set -u
#
# Checking args
#

source scripts/config.sh

if [[ ! -d "$SAMPLE_DIR" ]]; then
    echo "$SAMPLE does not exist. Please provide a directory containing files to process Job terminated."
    exit 1
fi

if [[ ! -f "$BACTERIAL_DB" ]]; then
    echo "$BACTERIAL_DB does not exist. Please provide an assembly file to process Job terminated."
    exit 1
fi

if [[ ! -f "$VIRAL_DB" ]]; then
    echo "$VIRAL_DB does not exist. Please provide a BLASTP database for viral proteins. Job terminated."
    exit 1
fi

if [[ ! -f "$FIG_LOG" ]]; then
    echo "$FIG_LOG does not exist. Please provide a FigFam log. Job terminated."
    exit 1
fi

if [[ ! -f "$TAX_LOG" ]]; then
    echo "$TAX_LOG does not exist. Please provide a taxonomic log. Job terminated."
    exit 1
fi

if [[ ! -d "$SCRIPT_DIR" ]]; then
    echo "$SCRIPT_DIR does not exist. Job terminated."
    exit 1
fi

#
# Job submission
#

PREV_JOB_ID=""
ARGS="-q $QUEUE -W group_list=$GROUP -M $MAIL_USER -m $MAIL_TYPE"


#
## 01-run-analysis
#


PROG2="01-run-analysis"
export STDERR_DIR2="$SCRIPT_DIR/err/$PROG2"
export STDOUT_DIR2="$SCRIPT_DIR/out/$PROG2"


init_dir "$STDERR_DIR2" "$STDOUT_DIR2"

export PRODIGAL_DIR="$SAMPLE_DIR/div/prodigal"
export SELECTED="$SAMPLE_DIR/div/selected"
export BLAST_DIR="$SAMPLE_DIR/blast"

init_dir "$PRODIGAL_DIR" "$SELECTED" "$BLAST_DIR"

export SPLIT="$SAMPLE_DIR/div/raw"

export FILES_LIST="$SPLIT/list-files"

cd $SPLIT

find . -type f -name "*.fasta" > $FILES_LIST

export NUM_FILES=$(lc $FILES_LIST)

echo Found \"$NUM_FILES\" files in \"$SPLIT\"

if [ $NUM_FILES -gt 0 ]; then

    if [ $NUM_FILES -gt 1 ]; then
         JOB_ID=`qsub $ARGS -v WORKER_DIR,SPLIT,PRODIGAL_DIR,PRODIGAL,SELECTED,BLAST_DIR,FILES_LIST,SAMPLE_DIR,STDERR_DIR2,STDOUT_DIR2,TAX_LOG,FIG_LOG,BACTERIAL_DB,VIRAL_DB -N run_analysis -e "$STDERR_DIR2" -o "$STDOUT_DIR2" -J 1-$NUM_FILES $SCRIPT_DIR/run_analysis_array.sh`

          if [ "${JOB_ID}x" != "x" ]; then
             echo Job: \"$JOB_ID\"
             PREV_JOB_ID=$JOB_ID
          else
              echo Problem submitting job.
          fi
     else
          XFILE=find . -type f -name "*.fasta" 
          JOB_ID=`qsub $ARGS -v WORKER_DIR,SPLIT,PRODIGAL_DIR,PRODIGAL,SELECTED,BLAST_DIR,XFILE,SAMPLE_DIR,STDERR_DIR2,STDOUT_DIR2,TAX_LOG,FIG_LOG,BACTERIAL_DB,VIRAL_DB -N run_analysis -e "$STDERR_DIR2" -o "$STDOUT_DIR2"  $SCRIPT_DIR/run_analysis.sh`

          if [ "${JOB_ID}x" != "x" ]; then
             echo Job: \"$JOB_ID\"
             PREV_JOB_ID=$JOB_ID
          else
              echo Problem submitting job.
          fi
      fi 

#
## 02- get-results
#

       PROG3="02-get-results"
       export STDERR_DIR3="$SCRIPT_DIR/err/$PROG3"
       export STDOUT_DIR3="$SCRIPT_DIR/out/$PROG3"


       init_dir "$STDERR_DIR3" "$STDOUT_DIR3"


        JOB_ID=`qsub -v WORKER_DIR,SAMPLE_DIR,STDERR_DIR3,STDOUT_DIR3 -N run_results -e "$STDERR_DIR3" -o "$STDOUT_DIR3" -W depend=afterok:$PREV_JOB_ID $SCRIPT_DIR/run_get_result.sh`

        if [ "${JOB_ID}x" != "x" ]; then
             echo Job: \"$JOB_ID\"
        else
             echo Problem submitting job.
        fi


        echo "job successfully submited"


else
    echo Nothing to do.
fi


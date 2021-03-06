#!/bin/sh
set -u
#
# Checking args
#

source scripts/config.sh

if [[ ! -f "$SAMPLE" ]]; then
    echo "$SAMPLE does not exist. Please provide an assembly file to process Job terminated."
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

if [[ ! -d "$SAMPLE_DIR" ]]; then
    echo "$SAMPLE_DIR does not exist. Directory created for output files."
    mkdir -p "$SAMPLE_DIR"
fi

#
# Job submission
#

PREV_JOB_ID=""
ARGS="-q $QUEUE -W group_list=$GROUP -M $MAIL_USER -m $MAIL_TYPE"

#
## 01-split-file
#

PROG="00-split-file"
export STDERR_DIR="$SCRIPT_DIR/err/$PROG"
export STDOUT_DIR="$SCRIPT_DIR/out/$PROG"

init_dir "$STDERR_DIR" "$STDOUT_DIR" "$SAMPLE_DIR"
export DIV="$SAMPLE_DIR/div"
init_dir "$DIV"
export SPLIT="$DIV/raw"
init_dir "$SPLIT"

JOB_ID=`qsub $ARGS -v WORKER_DIR,SAMPLE,SPLIT,STDERR_DIR,STDOUT_DIR -N run_split -e "$STDERR_DIR" -o "$STDOUT_DIR" $SCRIPT_DIR/run_split.sh`

if [ "${JOB_ID}x" != "x" ]; then
   echo Job: \"$JOB_ID\"
   PREV_JOB_ID=$JOB_ID
else
   echo Problem submitting job.
fi

echo "job successfully submited"

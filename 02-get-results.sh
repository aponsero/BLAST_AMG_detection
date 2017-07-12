#
# This script is intended to concat the results files in a unique log 
#

source ./config.sh

PROG="02-get_results"
export STDERR_DIR="$SCRIPT_DIR/err/$PROG"
export STDOUT_DIR="$SCRIPT_DIR/out/$PROG"

init_dir "$STDERR_DIR" "$STDOUT_DIR"

JOB_ID=`qsub -v WORKER_DIR,SAMPLE_DIR,STDERR_DIR,STDOUT_DIR -N run_results -e "$STDERR_DIR" -o "$STDOUT_DIR" $WORKER_DIR/run_get_result.sh`

if [ "${JOB_ID}x" != "x" ]; then
   echo Job: \"$JOB_ID\"
else
   echo Problem submitting job.
fi

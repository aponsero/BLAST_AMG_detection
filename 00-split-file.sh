#
# This script is intended to run the size filter to remove very short contigs and divide the sequences in managable files
#

source ./config.sh

PROG="00-split"
export STDERR_DIR="$SCRIPT_DIR/err/$PROG"
export STDOUT_DIR="$SCRIPT_DIR/out/$PROG"

init_dir "$STDERR_DIR" "$STDOUT_DIR" "$SAMPLE_DIR"
export DIV="$SAMPLE_DIR/div"
init_dir "$DIV"
export SPLIT="$DIV/raw"
init_dir "$SPLIT"


JOB_ID=`qsub -v WORKER_DIR,SAMPLE,SPLIT,STDERR_DIR,STDOUT_DIR -N run_split -e "$STDERR_DIR" -o "$STDOUT_DIR" $WORKER_DIR/run_split.sh`

if [ "${JOB_ID}x" != "x" ]; then
   echo Job: \"$JOB_ID\"
else
   echo Problem submitting job.
fi


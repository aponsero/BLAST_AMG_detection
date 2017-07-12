#
# This script is intended to run the prodigal cds annotation, followed by the blast query on the Bacterial database and the viral database. The final output is a log containing the potential AMGs (cds matching a bacterial protein on a contig containing one or more cds matching a viral protein)
#

source ./config.sh

PROG="01-run-analysis"
export STDERR_DIR="$SCRIPT_DIR/err/$PROG"
export STDOUT_DIR="$SCRIPT_DIR/out/$PROG"

init_dir "$STDERR_DIR" "$STDOUT_DIR"

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
    JOB_ID=`qsub -v WORKER_DIR,SPLIT,PRODIGAL_DIR,SELECTED,BLAST_DIR,FILES_LIST,SAMPLE_DIR,STDERR_DIR,STDOUT_DIR,TAX_LOG,FIG_LOG,BACTERIAL_DB,VIRAL_DB -N run_analysis -e "$STDERR_DIR" -o "$STDOUT_DIR" -J 1-$NUM_FILES $WORKER_DIR/run_analysis.sh`

    if [ "${JOB_ID}x" != "x" ]; then
        echo Job: \"$JOB_ID\"
    else
        echo Problem submitting job.
    fi
else
    echo Nothing to do.
fi

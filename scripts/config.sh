export CWD=$PWD
# where programs are
export BIN_DIR="/rsgrps/bhurwitz/hurwitzlab/bin"
export PRODIGAL="/rsgrps/bhurwitz/alise/tools/Prodigal/prodigal"
# where the sample to analyze are
export SAMPLE="YOUR/SAMPLE/PATH"
export SAMPLE_DIR="OUTPUT/DIR/PATH"
# scripts of the pipeline
export SCRIPT_DIR="$PWD/scripts"
export WORKER_DIR="$SCRIPT_DIR/workers"
#Where the blast Databases are
export BACTERIAL_DB="PATH/TO/DB"
export VIRAL_DB="PATH/TO/DB"
export FIG_LOG="PATH/TO/LOG"
export TAX_LOG="PATH/TO/LOG"
# Job submission informations
export QUEUE="standard"
export GROUP="yourgroup"
export MAIL_USER="youremail@email.arizona.edu"
export MAIL_TYPE="bea"


#
# --------------------------------------------------
function init_dir {
    for dir in $*; do
        if [ -d "$dir" ]; then
            rm -rf $dir/*
        else
            mkdir -p "$dir"
        fi
    done
}

# --------------------------------------------------
function lc() {
    wc -l $1 | cut -d ' ' -f 1
}

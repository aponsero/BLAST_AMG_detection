export CWD=$PWD
# where programs are
export BIN_DIR="/rsgrps/bhurwitz/hurwitzlab/bin"
# where the sample to analyze are
export SAMPLE="/rsgrps/bhurwitz/alise/my_data/TOV_assemblies/CENF01.fasta"
export SAMPLE_DIR="/rsgrps/bhurwitz/alise/my_data/BLAST_results/pipeline_AMG_test4"
# scripts of the pipeline
export SCRIPT_DIR=$PWD
export WORKER_DIR="$SCRIPT_DIR/workers"
#Where the blast Databases are
export BACTERIAL_DB="/rsgrps/bhurwitz/hurwitzlab/data/patric/genomes/marine_BLASTP_DB/MarineDB_c90"
export VIRAL_DB="/rsgrps/bhurwitz/alise/my_data/REFSEQ_DB/Viruses_PROTEINS/db90_blast_DB/viral_cds_protein_06-17_cl90_cor.faa"
export FIG_LOG="/rsgrps/bhurwitz/hurwitzlab/data/patric/genomes/marine_BLASTP_DB/figFam_log"
export TAX_LOG="/rsgrps/bhurwitz/hurwitzlab/data/patric/genomes/marine_BLASTP_DB/taxo_log"

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

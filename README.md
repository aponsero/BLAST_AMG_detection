# BLAST_AMG_detection
Pipeline for detection of potential AMG in assembled metagenome using BLASTP

## Requirements

### BLASTP databases
This pipeline necessites two distinct BLASTP databases. One should contain bacterial proteins and another only viral proteins. The databases should be accompanied with a log containing Figfam ID present in the bacterial database and their annotations. Finaly a taxonomic log should provide taxonomic informations regarding the bacterial sequences present in the database.
A pipeline to construct the bacterial database and necessary logs is available in https://github.com/aponsero/CreateDB-BLASTP-Patric .

### BLAST
ncbi-BLAST+ (at least version 2.3.0) should be previously installed and included in the user PATH.

### Prodigal
Prodigal (at least version 2.6) should be installed. The location of installation should be provided in the config file.
Prodigal is available at https://github.com/hyattpd/Prodigal .

## Quick start

### Edit scripts/config.sh file

please modify the

  - SAMPLE = indicate here the metagenome file to analyze
  - SAMPLE_DIR = indicate here the output directory
  - BACTERIAL_DB = indicate here the BLASTP Bacterial file (.faa)
  - VIRAL_DB = indicate here the BLASTP viral file (.faa)
  - FIG_LOG = indicate here the FigFam log
  - TAX_LOG = indicate here the taxonomic log
  - MAIL_USER = indicate here your arizona.edu email
  - GROUP = indicate here your group affiliation

You can also modify

  - BIN = change for your own bin directory.
  - PRODIGAL = give the prodigal install folder.
  - MAIL_TYPE = change the mail type option. By default set to "bea".
  - QUEUE = change the submission queue. By default set to "standard".
  
  ### Split input file
  
  Run ./split.sh
  
  This command will remove short contigs from the dataset (<500pb) and split the remaining contigs in manageable files for the analysis (10.000 contigs/files). The split files are stored in $SAMPLE_DIR/div/raw.
  
  Once the job is completed successfully, the analysis can be run.
  
  ### Run analysis
  
  Run ./submit.sh
  
  Will place in queue two successive jobs for the analysis.
  The final output is located in $SAMPLE_DIR/results_AMG.log

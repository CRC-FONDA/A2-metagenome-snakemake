# Metagenome read mapping approaches

The goal of this repository is to write workflow components for mapping metagenomics reads that can be used on different architectures. 

Data simulation: 
https://github.com/eseiler/raptor_data_simulation

STELLAR documentation:
https://github.com/seqan/seqan/tree/master/apps/stellar

Raptor documentation:
https://github.com/seqan/raptor

Yara read mapper:
https://github.com/seqan/seqan/blob/develop/apps/yara/README.rst

DREAM-Yara repo:
https://github.com/temehi/dream_yara
NB! DREAM-Yara is not available through conda, it has to be built from source. Also add location of binaries to $PATH.

To run the snakemake workflow:
`snakemake --use-conda --cores {e.g 8} --allow-ambiguity`

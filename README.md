# Metagenome read mapping approaches

This repository contains multiple examples of scientific workflows. The goal of this repository is to write workflow components for mapping metagenomics reads that can be used on different architectures. 

The workflows are currently run on two smaller metagenomic datasets:
* simulated DNA sequences (64MB reference https://github.com/eseiler/raptor_data_simulation)
* protein sequences from the bovine gut (200MB reference from https://omics.informatics.indiana.edu/mg/RAPSearch2/).

The repository is divided into subprojects, details of each below.

To run the snakemake workflow in one of the subfolders:
`snakemake --use-conda --cores {e.g 8} --allow-ambiguity`

## MG-1

This workflow is optimized to be run on a local system with large main memory and multiple threads. The large main memory is used when working with the IBF (at least 1GB) which has to be read completely into memory. The FM-indices, IBF creation and read mapping are done using 8 threads. 

**NOTE:** Raptor data simulation and DREAM-Yara are not available through conda and have to be built from source. Also add location of DREAM-Yara binaries to $PATH.

---

Raptor data simulation repo:
https://github.com/eseiler/raptor_data_simulation

---
---

DREAM-Yara repo:
https://github.com/temehi/dream_yara

---

## MG-2

This version of a metagenomics workflow aims to work around the constraint of having low memory. A hash table based approach is used instead of the IBF.

## MG-R 
This is a state of the art representative workflow for mapping metagenomic reads. NB! Needs an update.

---
taxSBP repo:
https://github.com/pirovc/taxsbp

**NOTE:** taxSBP requires additional inputs (merged.dmp and nodes.dmp) as well as a `seqinfo.tsv` file that has to be created specifically for each reference dataset. See tacSBP repo for more details. It might additionally be necessary to remove - and / characters from the reference file (.fasta sequence IDs).

## alternative_tools

This subprojects has currently been abandoned and might be broken. These are tools that did not fit into the representative workflow but are nevertheless state of the art and widely used.

STELLAR documentation:
https://github.com/seqan/seqan/tree/master/apps/stellar

Raptor documentation:
https://github.com/seqan/raptor

Yara read mapper:
https://github.com/seqan/seqan/blob/develop/apps/yara/README.rst

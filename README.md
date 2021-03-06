# Metagenome read mapping approaches

This repository contains examples of scientific workflows. The goal of this repository is to write workflow components for mapping metagenomics reads that can be used on different architectures. 

The repository is divided into subprojects, details of each below. Each MG-* project directory contains a Snakemake workflow.

## Benchmarking

There are git branches `allegro` for the allegro cluster and `redwood` for the redwood server (MG-1 and MG-3). Check the 80GB_benchmarks directory for benchmarking results on an 80GB reference database. 

---

### Running snakemake 

Prerequisites: 
- conda installation https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html
- active conda environment with snakemake installation https://snakemake.readthedocs.io/en/stable/getting_started/installation.html
- built from source:
  * https://github.com/eseiler/raptor_data_simulation
  * https://github.com/seqan/dream_yara (MG-1 and MG-3)
  * https://github.com/eaasna/low-memory-prefilter (MG-2)
  * https://github.com/eaasna/match-consolidator (MG-2)


Start by running the raptor_data_simulation workflow. Set input parameters in `simulation_config.yaml`.
```
cd raptor_data_simulation
snakemake --cores 1
```

Then set the search parameters in `search_config.yaml`. To run one of the MG-* snakemake workflows:
```
cd MG-1
snakemake --use-conda --cores {e.g 8}
```

Other useful flags:
1. `--force-use-threads` add this flag to force threads instead of processes in case each process takes too much local memory to be run in parallel 
2. `snakemake --dag | dot -Tpng > dag.png` don't run any jobs just create a figure of the directed acyclic graph
3. `snakemake --dryrun` don't run any jobs just display the order in which they would be executed.

---

## Simulated data

### raptor_data_simulation
Simulating DNA sequences with https://github.com/eseiler/raptor_data_simulation.
Run this workflow before running any of the MG-* workflows. The data simulation parameters are set in `simulation_config.yaml`. All MG-x workflows have a separate configuration file called `search_config.yaml` where prefiltering and search parameters should be set. 


### MG-R 
This is a state of the art representative workflow for mapping metagenomic reads. The prefiltering and read mapping steps of MG-R are identical to MG-1. MG-R additionally contains a species abundance estimation step.

Steps of workflow:
1. Create an IBF over the simulated reference data
2. Create an FM-index for each of the bins of the reference
3. Map each read to the FM-index determined by IBF pre-filtering
4. Sort and index the resulting .bam file and find the number of reads that mapped to each bin.

### MG-1
![directed acyclic graph for MG-1](https://github.com/eaasna/A2-metagenome-snakemake/blob/main/MG-1/dag.png)

This workflow is optimized to be run on a local system with large main memory and multiple threads. The large main memory is used when working with the IBF (at least 1GB) which has to be read completely into memory. The FM-indices, IBF creation and read mapping are done using 8 threads. 

Steps of workflow:
1. Create an IBF over the simulated reference data
2. Create an FM-index for each of the bins of the reference
3. Map each read to the FM-index determined by IBF pre-filtering. The read distribution is done in-memory.

![job counts for MG-1](https://github.com/eaasna/A2-metagenome-snakemake/blob/main/MG-1/job_counts.png)

### MG-2
![directed acyclic graph for MG-2](https://github.com/eaasna/A2-metagenome-snakemake/blob/main/MG-2/dag.png)

This version of a metagenomics workflow aims to work around the constraint of having low memory. A hash table based approach is used instead of the IBF.

Steps of workflow:
1. Create a hash table over the simulated reference data
2. Query the reads in the hashmap and determine potential bin matches
3. Distribute reads by writing e.g all reads that should be mapped to bin 1 to a file
4. Create an FM-index for each of the bins of the reference
5. Read the distributed reads and map to the FM-index determined by hashmap pre-filtering
6. If a read was mapped to multiple bins the strata mapping results have to be consolidated between bins. For match consolidation the mapping results are gathered into one file and filtered based on the best+x cutoff set by the user in the configuration file. 

![job counts for MG-2](https://github.com/eaasna/A2-metagenome-snakemake/blob/main/MG-2/job_counts.png)

### MG-3
![directed acyclic graph for MG-3](https://github.com/eaasna/A2-metagenome-snakemake/blob/main/MG-3/dag.png)

This workflow uses the same tools as MG-1 but divides the FM-index creation and read mapping between multiple jobs (as opposed to one multithreaded job). This is useful for running the workflow on the cluster.

Steps of workflow:
1. Create an IBF over the simulated reference data (one job)
2. Create an FM-index for each of the bins of the reference (one job per bin)
3. Map each read to the FM-index determined by IBF pre-filtering (one job per bin)

![job counts for MG-3](https://github.com/eaasna/A2-metagenome-snakemake/blob/main/MG-3/job_counts.png)

---

<details>
  <summary>Real data (work in progress)</summary>
  
  ### MG-R
  
The MG-R folder contains a bovine-protein branch that is a work in progress implementation of analysing protein metagenomics reads. The dataset has been downloaded from  https://omics.informatics.indiana.edu/mg/RAPSearch2/. 

Real data would have to be first taxonomically clustered with the taxSBP tool: 
https://github.com/pirovc/taxsbp

**NOTE:** taxSBP requires additional inputs (merged.dmp and nodes.dmp) which are currently not downloaded as part of the workflow. There is also a `seqinfo.tsv` file that has to be created specifically for each reference dataset. See tacSBP repo for more details. It might additionally be necessary to remove - and / characters from the reference file (.fasta sequence IDs).
</details>

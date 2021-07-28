# all parameters are set in config.yaml
#
# these parameters describe the simulated data
rer = config["read_error_rate"]
rl = config["read_length"]	

# these parameters describe the search
k = config["kmer_length"]
er = config["error_rate"]
bf = config["bf_size"]
h = config["nr_hashes"]


# This file contains distributed read mapping for simulated data. Simulated data was already created in bins.
#
# The filenames must follow a specific structure e.g 4.fastq NOT 04.fastq 
# renaming files:
import subprocess
subprocess.call(['bash', './scripts/rename_fasta.sh'])
subprocess.call(['bash', './scripts/rename_fastq.sh', rer, rl])

# create an IBF from clustered database
rule dream_IBF:
	input:
		expand("../simulated_data/bins/{bin}.fasta", bin = bins)
	output:
		"IBF.filter"
	params:
		t = 8
	shell:
		"dream_yara_build_filter --threads {params.t} --kmer-size {k} --filter-type bloom --bloom-size {bf} --num-hash {h} --output-file {output} {input}"

# create FM-indices for each bin
rule dream_FM_index:
	input:
		bins = expand("../simulated_data/bins/{bin}.fasta", bin = bins)
	output:
		expand("fm_indices/{bin}.sa.val", bin = bins)
	params:
		outdir = "fm_indices/",
		t = 8
	shell:
		"dream_yara_indexer --threads {params.t} --output-prefix {params.outdir} {input.bins}"
	
# map reads to bins that pass the IBF prefilter
rule dream_mapper:
	input:
		filter = "IBF.filter",
		index = "fm_indices/{bin}.sa.val",
		reads = "../simulated_data/reads_e" + rer + "_" + rl + "/{bin}.fastq"
	output:
		"mapped_reads/{bin}.bam"
	params:
		index_dir = "fm_indices/",
		t = 8
	shell:
		"dream_yara_mapper -t {params.t} -ft bloom -e {er} -fi {input.filter} -o {output} {params.index_dir} {input.reads}"

# all parameters are set in config.yaml
# these parameters describe the search
k = config["kmer_length"]
er = config["error_rate"]

# This file contains distributed read mapping for simulated data. Simulated data was already created in bins.

# create FM-indices for each bin
rule FM_index:
	input:
		bins = expand("data/" + str(bin_nr) + "/bins/{bin}.fasta", bin = bin_list)
	output:
		expand("fm_indices/{bin}.sa.val", bin = bin_list)
	params:
		outdir = "fm_indices/",
		t = 8
	shell:
		"dream_yara_indexer --threads {params.t} --output-prefix {params.outdir} {input.bins}"
	
# map reads to bins that were determined by the hashmap k-mer lemma filter
rule mapper:
	input:
		filter = "IBF.filter",
		index = "fm_indices/{bin}.sa.val",
		reads = "data/" + str(bin_nr) + "/reads_e" + str(rer) + "_" + str(rl) + "/{bin}.fastq"
	output:
		"mapped_reads/{bin}.bam"
	params:
		index_dir = "fm_indices/",
		t = 8
	shell:
		"dream_yara_mapper -t {params.t} -ft bloom -e {er} -fi {input.filter} -o {output} {params.index_dir} {input.reads}"

# all parameters are set in config.yaml
# these parameters describe the search
k = config["kmer_length"]
ep = round(epr / rl * 100) 		# percentage of errors allowed in an approximate match (int)

# This file contains distributed read mapping for simulated data. Simulated data was already created in bins.

# create FM-indices for each bin
rule dream_FM_index:
	input:
		bins = expand("../data/" + str(bin_nr) + "/bins/{bin}.fasta", bin = bin_list)
	output:
		expand("fm_indices/{bin}.sa.val", bin = bin_list)
	params:
		outdir = "fm_indices/",
		t = 8
	shell:
		"dream_yara_indexer --threads {params.t} --output-prefix {params.outdir} {input.bins}"


# call bash script that acts as read mapping distributor
# TODO: delete distributed read files after not used anymore
rule search_distributor:
	input:
		matches = "hashmap/all.output",
		all = "../data/" + str(bin_nr) + "/reads_e" + str(epr) + "_" + str(rl) + "/all.fastq"
	output:
		expand("distributed_reads/{bin}.fastq", bin = bin_list)
	shell:
		"./scripts/search_distributor.sh {input.matches} {input.all} {bin_nr}"

# map reads to bins that were determined by the hashmap k-mer lemma filter
rule yara_mapper:
	input:
		reads = "distributed_reads/{bin}.fastq",
		index = "fm_indices/{bin}.sa.val"
	output:
		"mapped_reads/{bin}.bam"
	conda:
		"../envs/yara.yaml"
	params:
		prefix = "fm_indices/{bin}",
	shell:
		"yara_mapper -e {ep} -o {output} {params.prefix} {input.reads}"

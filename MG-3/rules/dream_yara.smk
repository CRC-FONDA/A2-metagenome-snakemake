# Search parameters (besides error rate)  are set in config.yaml
configfile: "../A2-metagenome-snakemake/search_config.yaml"

# Parameters for the search
k = config["kmer_length"]
er = config["allowed_errors"] / rl              # this is the allowed error rate for an approximate match
sp = round(config["strata_width"] / rl * 100)

bf = config["bf_size"]
h = config["nr_hashes"]


# This file contains distributed read mapping for simulated data. Simulated data was already created in bins.
#
# create an IBF from clustered database
rule dream_IBF:
	input:
		expand("../" + str(bin_nr) + "/bins/{bin}.fasta", bin = bin_list)
	output:
		"dream.filter"
	threads: 40
	resources:
		mem_mb = 1000
	benchmark:
		"benchmarks/IBF.txt"
	shell:
		"dream_yara_build_filter --threads {threads} --kmer-size {k} --filter-type bloom --bloom-size {bf} --num-hash {h} --output-file {output} {input}"

# create FM-indices for each bin
# by default: number of jobs == number of bins
# this can be adjusted with command line arguments (see README)
rule dream_FM_index:
	input:
		"../" + str(bin_nr) + "/bins/{bin}.fasta"
	output:
		"fm_indices/{bin}.sa.val"
	params:
		outdir = "fm_indices/{bin}."
	threads: 4
	benchmark:
		repeat("benchmarks/fm_{bin}.txt", 2)
	shell:
		"""
		dream_yara_indexer --threads {threads} --output-prefix {params.outdir} {input}
		
		for file in fm_indices/{wildcards.bin}.0.*
		do
			mv "$file" "${{file/.0/}}"
		done
		"""
	
# map reads to bins that pass the IBF prefilter
rule dream_mapper:
	input:
		filter = "dream.filter",
		index = expand("fm_indices/{bin}.sa.val", bin=bin_list),
		reads = "../" + str(bin_nr) + "/reads_e" + str(epr) + "_" + str(rl) + "/{bin}.fastq"
	output:
		"mapped_reads/{bin}.sam"
	params:
		index_dir = "fm_indices/"
	threads: 4
	benchmark:
		repeat("benchmarks/mapped_{bin}.txt", 2)
	shell:
		"dream_yara_mapper -t {threads} -ft bloom -e {er} -s {sp} -y full -fi {input.filter} -o {output} {params.index_dir} {input.reads}"

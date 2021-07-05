# 
# linear mapping 
#
# create a single index for one bin and map reads against it
rule yara_indexer:
	input:
		"simulated_data/bins/{bin}.fasta"
	output:
		"yara_out/indices/{bin}.index.sa.val"
	conda: 
		"../envs/yara.yaml"
	params:
		out = "yara_out/indices/{bin}.index"
	shell:
		"yara_indexer {input} -o {params.out}"

rule yara_mapper:
	input:
		index = "yara_out/indices/{bin}.index.sa.val",
		reads = "simulated_data/reads_e5_150/{bin}.fastq"
	output:
		"yara_out/{bin}.bam"
	params:
		prefix = "yara_out/indices/{bin}.index"
	conda: 
		"../envs/yara.yaml"
	shell:
		"yara_mapper {params.prefix} {input.reads} -o {output}"
	
# mock clustering
rule bin_reference:
	input:
		"simulated_data/all_bins.fasta"
	output:
		expand("simulated_data/bins_dream/{bin}.fasta", bin = all_bins)
	shell:
		"echo Clustering"

# 
# distributed read mapping
#
# The filenames must follow a specific structure e.g 4.fastq NOT 04.fastq 
#
# create an IBF from clustered database
rule dream_IBF:
	input:
		expand("simulated_data/bins_dream/{bin}.fasta", bin = all_bins)
	output:
		"dream_out/IBF.filter"
	params:
		k = 19,
		t = 8
	shell:
		"dream_yara_build_filter --threads {params.t} --kmer-size {params.k} --filter-type bloom --bloom-size 1 --num-hash 3 --output-file {output} {input}"

# create FM-indices for each bin
rule dream_FM_index:
	input:
		bins = expand("simulated_data/bins_dream/{bin}.fasta", bin = all_bins)
	output:
		expand("dream_out/indices/{bin}.sa.val", bin = all_bins)
	params:
		outdir = "dream_out/indices/",
		t = 8
	shell:
		"""
		dream_yara_indexer --threads {params.t} --output-prefix {params.outdir} {input.bins}
		"""
		
# map reads to bins that pass the IBF prefilter
rule dream_mapper:
	input:
		filter = "dream_out/IBF.filter",
		index = "dream_out/indices/{bin}.sa.val",
		reads = "simulated_data/reads_e5_150_dream/{bin}.fastq"
	output:
		"dream_out/{bin}.bam"
	params:
		index_dir = "dream_out/indices/",
		er = 0.01,
		t = 8
	shell:
		"dream_yara_mapper -t {params.t} -ft bloom -e {params.er} -fi {input.filter} -o {output} {params.index_dir} {input.reads}"


# mock gathering
rule estimate_abundance:
	input:
		expand("dream_out/{bin}.bam", bin = all_bins)
	output:
		"all_bins.bam"
	shell:
		"touch all_bins.bam"

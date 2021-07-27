# 
# linear mapping 
#
# create a single index for one bin and map reads against it
rule yara_indexer:
	input:
		"../simulated_data/bins/{bin}.fasta"
	output:
		"yara_out/indices/{bin}.index.sa.val"
	conda: 
		"../envs/yara.yaml"
	params:
		out = "yara_out/indices/{bin}.index"
	shell:
		"yara_indexer {input} -o {params.out}"

# one-to-one mapping between bin of reads and index
rule yara_mapper:
	input:
		index = "yara_out/indices/{bin}.index.sa.val",
		reads = "../simulated_data/reads_e5_150/{bin}.fastq"
	output:
		"yara_out/{bin}.bam"
	params:
		prefix = "yara_out/indices/{bin}.index"
	conda: 
		"../envs/yara.yaml"
	shell:
		"yara_mapper {params.prefix} {input.reads} -o {output}"

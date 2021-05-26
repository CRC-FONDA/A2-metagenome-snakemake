rule indexer:
	input:
		"simulated_data/bins/{bin}.fasta"
	output:
		"yara_out/{bin}.index.sa.val"
	conda: 
		"../envs/yara.yaml"
	shell:
		"yara_indexer {input} -o {output}"

rule mapper:
	input:
		index = "yara_out/{bin}.index.sa.val",
		reads = "simulated_data/reads_e5_150/{bin}.fastq"
	output:
		"yara_out/{bin}.bam"
	params:
		prefix = "yara_out/{bin}.index"
	conda: 
		"../envs/yara.yaml"
	shell:
		"yara_mapper {params.prefix} {input.reads} -o {output}"
	


rule map_reads:
	input:
		"../data/64/reads_e{rer}_150/{bin}.fastq"
	output:
		"../"
	params:
		er = 0.001
	conda: 
		"../envs/yara.yaml"
	shell:


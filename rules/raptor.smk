rule raptor_build:
	input:
		"simulated_data/all_bin_paths.txt"
	output:
		"raptor_out/raptor_w{w}_k{k}_{s}.index"
	shell:
		"raptor build --window {wildcards.w} --kmer {wildcards.w} --size {wildcards.s} --output {output} {input}"

rule raptor_search:
	input:
		index = "raptor_out/raptor_w{w}_k{k}_{s}.index",
		reads = "simulated_data/reads_e5_150/bin_{bin}.fastq"
	output:
		"raptor_out/bin{bin}_w{w}_k{k}_e{e}.hits"
	shell:
		"raptor search --window {wildcards.w} --kmer {wildcards.k} --error {wildcards.e} --index {input.index} --query {input.reads} --output {output}"	

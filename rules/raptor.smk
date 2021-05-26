rule raptor_build:
	input:
		"simulated_data/all_bin_paths.txt"
	output:
		"raptor_out/raptor_w{w}_k{k}_80m.index"
	conda:
		"../envs/raptor.yaml"
	shell:
		"raptor build --window {wildcards.w} --kmer {wildcards.w} --size 80m --output {output} {input}"

rule raptor_search:
	input:
		index = "raptor_out/raptor_w{w}_k{k}_80m.index",
		reads = "simulated_data/reads_e5_150/{bin}.fastq"
	output:
		"raptor_out/{bin}_w{w}_k{k}_e{e}.hits"
	conda:
		"../envs/raptor.yaml"
	shell:
		"raptor search --window {wildcards.w} --kmer {wildcards.k} --error {wildcards.e} --index {input.index} --query {input.reads} --output {output}"	

# Prefiltering and search parameters are set in search_config.yaml
configfile: "search_config.yaml"

# these parameters describe the prefiltering
k = config["kmer_length"]
#TODO: some application ask for error rate, others for number of errors 
er = config["errors"]

import subprocess
subprocess.call(['bash', './scripts/paths.sh', str(bin_nr)])

rule build_prefilter:
	input:
		paths = "metadata/bin_paths.txt",
		bins = expand("../data/" + str(bin_nr) + "/bins/{bin}.fasta", bin = bin_list)
	output:
		"hashmap/filter"
	shell:
		"./../../low-memory-prefilter/build/bin/hashmap build --kmer {k} --output {output} {input.paths}"

rule search_prefilter:
	input:
		filter = "hashmap/filter",
		reads = "../data/" + str(bin_nr) + "/reads_e" + str(epr) + "_" + str(rl) + "/all.fastq"
	output:
		"hashmap/all.output"
	params:
		t = 8
	shell:
		"./../../low-memory-prefilter/build/bin/hashmap search --threads {params.t} --error {er} --hashmap {input.filter} --output {output} {input.reads}"

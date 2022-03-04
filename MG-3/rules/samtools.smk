# -----------------------------
# 
# Rule resources for sorting:
# m: max memory per thread in bytes (default is 500000000)
# t: threads (default single threaded)
#
# thread and memory parameters could also be added to the index and stats commands
# -----------------------------

rule samtools_merge:
	input:
		expand("{params.dir}/mapped_reads/{bin}.sam", bin=bin_list)
	output:
		"{params.dir}/mapped_reads/all.sam"
	conda:
		"../../envs/samtools.yaml"
        params:
                t = 10,
                #m = 500000000,
                dir = "../../NO_BACKUP/simulated_metagenome/MG3",
		extra_threads = 9
	resources:
		nodelist = "cmp[240]"
	benchmark:
		"{params.dir}/benchmarks/merge.txt"
	shell:
		"samtools merge {input} -o {output} --threads {params.extra_threads}"

rule samtools_collate:
	input:
		"{params.dir}/mapped_reads/all.sam"
	output:
		"{params.dir}/mapped_reads/all_sorted.sam"
	conda:
		"../../envs/samtools.yaml"
        params:
                t = 10,
                #m = 500000000,
                dir = "../../NO_BACKUP/simulated_metagenome/MG3",
		extra_threads = 9
	resources:
		nodelist = "cmp[240]"
	benchmark:
		"{params.dir}/benchmarks/collate.txt"
	shell:
		"samtools collate {input} -o {output} --threads {params.extra_threads}"


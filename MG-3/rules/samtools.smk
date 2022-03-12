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
		expand("mapped_reads/{bin}.sam", bin=bin_list)
	output:
		"mapped_reads/all.sam"
	conda:
		"../../envs/samtools.yaml"
	params:
		extra_threads = 9
	threads: 10
	benchmark:
		repeat("benchmarks/merge.txt", 2)
	shell:
		"samtools merge {input} -o {output} --threads {params.extra_threads}"

rule samtools_collate:
	input:
		"mapped_reads/all.sam"
	output:
		"mapped_reads/all_sorted.sam"
	conda:
		"../../envs/samtools.yaml"
	params:
		extra_threads = 9
	threads: 10
	benchmark:
		repeat("benchmarks/collate.txt", 2)
	shell:
		"samtools collate {input} -o {output} --threads {params.extra_threads}"


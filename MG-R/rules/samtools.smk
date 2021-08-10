# -----------------------------
# 
# Rule resources for sorting:
# m: max memory per thread in bytes (default is 500000000)
# t: threads (default single threaded)
#
# thread and memory parameters could also be added to the index and stats commands
# -----------------------------

rule samtools_sort:
	input:
		"mapped_reads/all.bam"
	output:
		"mapped_reads/all_sorted.bam"
	conda:
		"../envs/samtools.yaml"
	params:
		t = 1,
		m = 500000000
	shell:
		"samtools sort -m {params.m} -@ {params.t} {input} -o {output}"

rule samtools_index:
	input:
		"mapped_reads/all_sorted.bam"
	output:
		"mapped_reads/all_sorted.bam.bai"
	conda:
		"../envs/samtools.yaml"
	shell:
		"samtools index {input}"


rule samtools_stats:
	input:
		reads = "mapped_reads/all_sorted.bam",
		index = "mapped_reads/all_sorted.bam.bai"
	output:
		"mapped_reads/idxstats.out"
	conda:
		"../envs/samtools.yaml"
	shell:
		"samtools idxstats {input.reads} > {output}"

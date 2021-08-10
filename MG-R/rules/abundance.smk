rule samtools_sort:
	input:
		"mapped_reads/all.bam"
	output:
		"mapped_reads/all_sorted.bam"
	conda:
		"../envs/samtools.yaml"
	shell:
		"samtools sort {input} -o {output}"

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

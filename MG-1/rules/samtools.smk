# -----------------------------
# 
# Rule resources for sorting:
# m: max memory per thread in bytes (default is 500000000)
# t: threads (default single threaded)
#
# thread and memory parameters could also be added to the index and stats commands
# -----------------------------

rule samtools_collate:
	input:
		"mapped_reads/all.sam"
	output:
		"mapped_reads/all_sorted.sam"
	conda:
		"../../envs/samtools.yaml"
	params:
		t = 1,
		m = 500000000
	shell:
		"samtools collate {input} -o {output}"


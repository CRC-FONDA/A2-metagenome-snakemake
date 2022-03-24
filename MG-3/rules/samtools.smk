# -----------------------------
# Samtools collate groups reads together by name.
# Faster alternative to sorting.
# -----------------------------

rule samtools_merge:
	input:
		expand("mapped_reads/{bin}.sam", bin=bin_list)
	output:
		"mapped_reads/all.sam"
        params:
		extra_threads = 9
	threads: 10
	resources:
		nodelist = "cmp[241]",
		mem_mb = 10000
	benchmark:
		repeat("benchmarks/merge.txt", 2)
	shell:
		"samtools merge {input} -o {output} --threads {params.extra_threads}"

rule samtools_collate:
	input:
		"mapped_reads/all.sam"
	output:
		"mapped_reads/all_sorted.sam"
        params:
		extra_threads = 9
	threads: 10
	resources:
		nodelist = "cmp[241]",
		mem_mb = 10000
	benchmark:
		repeat("benchmarks/collate.txt", 2)
	shell:
		"samtools collate {input} -o {output} --threads {params.extra_threads}"


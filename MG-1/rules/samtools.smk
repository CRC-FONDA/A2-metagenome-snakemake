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
		"/home/evelia95/A2-metagenome-snakemake/MG-1/envs/samtools.yaml"
	params:
		t = 10,
		#m = 500000000,
		extra_threads = 9
	resources:
		nodelist = "cmp[250]"
	benchmark:
		"benchmarks/collate.txt"
	shell:
		"samtools collate {input} -o {output} --threads {params.extra_threads}"


rule cluster_reference:
	input:
		ref = "bovine_gut/nogCOGdomN95.seq",
		info = "bovine_gut/seqinfo.tsv",
		nodes = "bovine_gut/nodes.dmp"
	output:
		"bovine_gut/bininfo.tsv"
	conda:
		"../envs/tax.yaml"
	params:
		bins = 128
	shell:
		"taxsbp -i {input.info} -n {input.nodes} -b {params.bins} -o {output} || true"

rule tax_to_bins:
	input:
		ref = "bovine_gut/nogCOGdomN95.seq",
		info = "bovine_gut/bininfo.tsv"
	output:
		expand("bovine_gut/{bin}.fasta", bin = bovine_bins)
	shell:
		""

# create an IBF from clustered database
rule IBF:
        input:
                expand("bovine_gut/{bin}.fasta", bin = bovine_bins)
        output:
                "bovine_gut/IBF.filter"
        params:
                k = 19,
                t = 8
        shell:
                "dream_yara_build_filter --threads {params.t} --kmer-size {params.k} --filter-type bloom --bloom-size 1 --num-hash 3 --output-file {output} {input}"

# create FM-indices for each bin
rule FM_index:
        input:
                bins = expand("bovine_gut/{bin}.fasta", bin = bovine_bins)
        output:
                expand("bovine_gut/indices/{bin}.sa.val", bin = bovine_bins)
        params:
                outdir = "bovine_gut/indices/",
                t = 8
        shell:
                """
                dream_yara_indexer --threads {params.t} --output-prefix {params.outdir} {input.bins}
                """

# map reads to bins that pass the IBF prefilter
rule distributed_mapper:
        input:
                filter = "bovine_gut/IBF.filter",
                index = "bovine_gut/indices/{bin}.sa.val",
                reads = "bovine_gut/4440037.dna.fa"
        output:
                "bovine_gut/{bin}.bam"
        params:
                index_dir = "bovine_gut/indices/",
                er = 0.01,
                t = 8
        shell:
                "dream_yara_mapper -t {params.t} -ft bloom -e {params.er} -fi {input.filter} -o {output} {params.index_dir} {input.reads}"
 

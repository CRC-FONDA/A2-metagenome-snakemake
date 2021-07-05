# Before the reference can be clustered with TaxSBP you need to: 
#	download merged.dmp and nodes.dmp
#	create seqinfo.tsv (can not be automated, depends on dataset)
#	for the bovine gut dataset it was necessary to remove - and / symbols from the reference
#
# Check https://github.com/pirovc/taxsbp for more details
#
# Decide which species of the reference database belongs to which bin; based on their taxonomy.
rule cluster_reference:
	input:
		ref = "../bovine_gut/nogCOGdomN95.seq",
		info = "../bovine_gut/seqinfo.tsv",
		nodes = "../bovine_gut/nodes.dmp"
	output:
		"bovine_out/bininfo.tsv"
	conda:
		"../envs/tax.yaml"
	params:
		bins = 128
	shell:
		"taxsbp -i {input.info} -n {input.nodes} -b {params.bins} -o {output} || true"

# Actually divide the intial reference which contains all reference sequences into bin files.
rule tax_to_bins:
	input:
		ref = "../bovine_gut/nogCOGdomN95.seq",
		info = "bovine_out/bininfo.tsv"
	output:
		expand("bovine_out/{bin}.fasta", bin = bovine_bins)
	shell:
		"./scripts/tax_to_bins.sh"

# TODO: this dataset has protein sequences!!

# create an IBF from clustered database
rule IBF:
        input:
                expand("bovine_out/{bin}.fasta", bin = bovine_bins)
        output:
                "bovine_out/IBF.filter"
        params:
                k = 19,
                t = 8
        shell:
                "dream_yara_build_filter --threads {params.t} --kmer-size {params.k} --filter-type bloom --bloom-size 1 --num-hash 3 --output-file {output} {input}"

# create FM-indices for each bin
rule FM_index:
        input:
                bins = expand("bovine_out/{bin}.fasta", bin = bovine_bins)
        output:
                expand("bovine_out/indices/{bin}.sa.val", bin = bovine_bins)
        params:
                outdir = "bovine_out/indices/",
                t = 8
        shell:
                """
                dream_yara_indexer --threads {params.t} --output-prefix {params.outdir} {input.bins}
                """

# map reads to bins that pass the IBF prefilter
rule distributed_mapper:
        input:
                filter = "bovine_out/IBF.filter",
                index = "bovine_out/indices/{bin}.sa.val",
                reads = "../bovine_gut/4440037.3.dna.fa"
        output:
                "bovine_out/{bin}.bam"
        params:
                index_dir = "bovine_out/indices/",
                er = 0.01,
                t = 8
        shell:
                "dream_yara_mapper -t {params.t} -ft bloom -e {params.er} -fi {input.filter} -o {output} {params.index_dir} {input.reads}"

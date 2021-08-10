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

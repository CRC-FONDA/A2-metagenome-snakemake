# Search parameters (besides error rate)  are set in config.yaml
configfile: "search_config.yaml"

# Parameters for the search
k = config["kmer_length"]
er = config["allowed_errors"] / rl              # this is the allowed error rate for an approximate match
sp = round(config["strata_width"] / rl * 100)

bf = config["bf_size"]
h = config["nr_hashes"]


# This file contains distributed read mapping for simulated data. Simulated data was already created in bins.
#
# create an IBF from clustered database
rule dream_IBF:
	input:
		expand("{params.dir}/" + str(bin_nr) + "/bins/{bin}.fasta", bin = bin_list)
	output:
		"{params.dir}/IBF.filter"
	params:
		t = 40,
		dir = "../../NO_BACKUP/simulated_metagenome/MG1"
	resources:
		nodelist = "cmp[249]"
	shell:
		"dream_yara_build_filter --threads {params.t} --kmer-size {k} --filter-type bloom --bloom-size {bf} --num-hash {h} --output-file {output} {input}"

# create FM-indices for each bin
rule dream_FM_index:
	input:
		bins = expand("{params.dir}/" + str(bin_nr) + "/bins/{bin}.fasta", bin = bin_list)
	output:
		expand("{params.dir}/fm_indices/{bin}.sa.val", bin = bin_list)
	params:
		outdir = "../..NO_BACKUP/simulated_metagenome/MG1/fm_indices/",
		t = 40,
		dir = "../../NO_BACKUP/simulated_metagenome/MG1"
	resources:
		nodelist = "cmp[249]"
	shell:
		"dream_yara_indexer --threads {params.t} --output-prefix {params.outdir} {input.bins}"
	
# map reads to bins that pass the IBF prefilter
rule dream_mapper:
	input:
		filter = "{params.dir}/IBF.filter",
		index = expand("{params.dir}/fm_indices/{bin}.sa.val", bin = bin_list),
		reads = "{params.dir}/" + str(bin_nr) + "/reads_e" + str(epr) + "_" + str(rl) + "/all.fastq"
	output:
		"{params.dir}/mapped_reads/all.sam"
	params:
		index_dir = "../../NO_BACKUP/simulated_metagenome/MG1/fm_indices/",
		t = 40,
		dir = "../../NO_BACKUP/simulated_metagenome/MG1"
	resources:
		nodelist = "cmp[249]"
	shell:
		"dream_yara_mapper -t {params.t} -ft bloom -e {er} -s {sp} -y full -fi {input.filter} -o {output} {params.index_dir} {input.reads}"

# stellar query sequences have to be in fasta format
rule convert_fastq:
	input:
		"simulated_data/reads_e5_150/{bin}.fastq"
	output:
		"simulated_data/reads_e5_150/{bin}.fasta"
	shell:
		"sed -n '1~4s/^@/>/p;2~4p' {input} > {output}"

# map reads from one bin against all references
rule stellar:
	input:
		reads = "simulated_data/reads_e5_150/{bin}.fasta",
		reference = "simulated_data/all_bins.fasta"
	output:
		"stellar_out/{bin}_l{l}_er{er}.gff"
	conda:
		"../envs/stellar.yaml"
	shell:
		"stellar -e {wildcards.er} -l {wildcards.l} {input.reference} {input.reads} -o {output}"

rule remove_metadata:
	input:
		"stellar_out/{bin}_l{l}_er{er}.gff"
	output:
		"stellar_out/{bin}_l{l}_er{er}_sed.gff"
	shell:
		"sed 's/;.*//' {input} > {output}"
		

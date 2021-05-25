# stellar query sequences have to be in fasta format
rule convert_fastq:
	input:
		"simulated_data/reads_e5_150/{bin}.fastq"
	output:
		"simulated_data/reads_e5_150/{bin}.fasta"
	shell:
		"sed -n '1~4s/^@/>/p;2~4p' {input} > {output}"

rule stellar:
	input:
		reads = "simulated_data/reads_e5_150/{bin}.fasta",
		reference = "simulated_data/all_bins.fasta"
	output:
		"stellar_out/bin{bin}_l{l}_e{e}.gff"
	params:
		er = 0.04
	conda:
		"../envs/stellar.yaml"
	shell:
		"stellar -e {params.er} -l {wildcards.l} {input.reference} {input.reads} -o {output}"

rule remove_metadata:
	input:
		"stellar_out/bin{bin}_l{l}_e{e}.gff"
	output:
		"stellar_out/bin{bin}_l{l}_e{e}_sed.gff"
	shell:
		"sed 's/;.*//' {input} > {output}"
		

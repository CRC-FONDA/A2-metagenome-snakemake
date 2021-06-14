#load  samples  into  table
import  pandas  as pd
import os

configfile: "config.yaml"
with open(config["bins"]) as f:
    bins = f.read().splitlines()

with open(config["all_bins"]) as f:
    all_bins = f.read().splitlines()

rule make_all:
	input:
		expand("raptor_out/{bin}_w{w}_k{k}_e{e}.hits", bin = bins, w = config["w"], k = config["k"], e = config["e"]),
		expand("stellar_out/{bin}_l{l}_er{er}_sed.gff", bin = bins, l = config["l"], er = config["er"]),
		expand("yara_out/{bin}.bam", bin = bins),
		expand("dream_out/{bin}.bam", bin = all_bins),
		"bovine_gut/bininfo.tsv"
	shell:
		"echo 'Done'"

include: "rules/raptor.smk"
include: "rules/stellar.smk"
include: "rules/yara.smk"
include: "rules/bovine.smk"

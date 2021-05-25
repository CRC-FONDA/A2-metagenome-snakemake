#load  samples  into  table
import  pandas  as pd
import os

configfile: "config.yaml"
with open(config["bins"]) as f:
    bins = f.read().splitlines()


rule make_all:
	input:
		expand("raptor_out/bin{bin}_w{w}_k{k}_e{e}.hits", bin = bins, w = config["w"], k = config["k"], e = config["e"]),
		expand("stellar_out/bin{bin}_l{l}_e{e}_sed.gff", bin = bins, l = config["l"], e = config["e"]) # need to set er separately
	shell:
		"echo 'Done'"

include: "rules/raptor.smk"
include: "rules/stellar.smk"

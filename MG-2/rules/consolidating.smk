# -----------------------------
# 
# Rule resources for sorting:
# m: max memory per thread in bytes (default is 500000000)
# t: threads (default single threaded)
#
# thread and memory parameters could also be added to the index and stats commands
# -----------------------------

rule samtools_convert:
        input:
                "mapped_reads/{bin}.bam"
        output:
                "mapped_reads/{bin}.sam"
        conda:
                "../../envs/samtools.yaml"
        shell:
                "samtools view {input} > {output}"

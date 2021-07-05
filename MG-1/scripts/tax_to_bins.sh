#!/bin/bash

BINS=152

for ((i=0;i<=BINS;i++)); do
	awk '$6==i {print $1}' bovine_out/bininfo.tsv > binIDs
	grep -A 1 -f binIDs ../bovine_gut/nogCOGdomN95.seq | sed '/--/d' > "bovine_out/${i}.fasta"
	rm binIDs
done

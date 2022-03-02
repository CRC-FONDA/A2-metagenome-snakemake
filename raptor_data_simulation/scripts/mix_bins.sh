#!/bin/bash

OUT_DIR=/home/evelia95/NO_BACKUP/simulated_metagenome/bins

echo "${OUT_DIR}"
cd $OUT_DIR

echo "Mixing haplotypes between bins..."

awk '{f=NR ".0"; print ">" $0 > f}' RS='>' 0.fasta
awk '{f=NR ".1"; print ">" $0 > f}' RS='>' 1.fasta
rm 0.fasta 1.fasta 1.0 1.1
cat 2.0 3.0 2.1 3.1 > 0.fasta
cat 4.0 5.0 4.1 5.1 > 1.fasta
rm *.0 *.1

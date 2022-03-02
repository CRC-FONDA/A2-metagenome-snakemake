#!/usr/bin/env bash
set -e

BINARY_DIR=${1}
OUT_DIR=${2}
PART=${3}
BIN_NUMBER=${4}
ERRORS=${5}
READ_LENGTHS=${6}
READ_COUNT=${7}
HAPLOTYPE_COUNT=${8}

output_dir=$OUT_DIR/part_$PART
bin_dir=$output_dir/bins
info_dir=$output_dir/info

mkdir -p $output_dir
mkdir -p $bin_dir
mkdir -p $info_dir

for read_length in $READ_LENGTHS
do
    echo "Generating $READ_COUNT reads of length $read_length with $ERRORS errors"
    read_dir=$output_dir/reads
    mkdir -p $read_dir
    $BINARY_DIR/generate_reads \
        --output $read_dir \
        --max_errors $ERRORS \
        --number_of_reads $READ_COUNT \
        --read_length $read_length \
        --number_of_haplotypes $HAPLOTYPE_COUNT \
        $(seq -f "$output_dir/bins/bin_%0${#BIN_NUMBER}g.fasta" 0 1 $((BIN_NUMBER-1))) > /dev/null
    cat $read_dir/*.fastq > $read_dir/all
    mv $read_dir/all $read_dir/all.fastq
    for i in $(seq 0 9); do cat $read_dir/all.fastq >> $read_dir/all_10.fastq; done
done

echo "renaming read files"
for file in $read_dir/bin_*.fastq; do
	mv "$file" "${file#bin_}";
done;

for file in $read_dir/0000[0-9]*.fastq; do
	mv "$file" "${file#0}";
done;
for file in $read_dir/000[0-9]*.fastq; do
	mv "$file" "${file#0}";
done;
for file in $read_dir/00[0-9]*.fastq; do
	mv "$file" "${file#0}";
done;
for file in $read_dir/0[0-9]*.fastq; do
	mv "$file" "${file#0}";
done;

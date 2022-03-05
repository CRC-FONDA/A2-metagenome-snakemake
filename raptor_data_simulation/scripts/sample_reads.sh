#!/usr/bin/env bash
set -e

BINARY_DIR=${1}
OUT_DIR=${2}
BIN_NUMBER=${3}
ERRORS=${4}
READ_LENGTHS=${5}
READ_COUNT=${6}
HAPLOTYPE_COUNT=${7}

output_dir=$OUT_DIR
bin_dir=$output_dir/bins
info_dir=$output_dir/info

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
        $(seq -f "$output_dir/bins/%0g.fasta" 0 1 $((BIN_NUMBER-1))) > /dev/null
    echo "Finished read sampling"
#    cat $read_dir/*.fastq > $read_dir/all
#    mv $read_dir/all $read_dir/all.fastq
#    for i in $(seq 0 9); do cat $read_dir/all.fastq >> $read_dir/all_10.fastq; done
done


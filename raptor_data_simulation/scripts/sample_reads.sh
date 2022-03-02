#!/usr/bin/env bash
set -e

BINARY_DIR=/home/evelia95/raptor_data_simulation/build/bin
OUT_DIR=/home/evelia95/NO_BACKUP/simulated_metagenome
BIN_NUMBER=${1}
ERRORS=${2}
READ_LENGTHS=${3}
READ_COUNT=${4}
HAPLOTYPE_COUNT=${5}

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


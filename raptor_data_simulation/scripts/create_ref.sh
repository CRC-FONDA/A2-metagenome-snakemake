#!/usr/bin/env bash
set -e

BINARY_DIR=/home/evelia95/raptor_data_simulation/build/bin
OUT_DIR=/home/evelia95/NO_BACKUP/simulated_metagenome
LENGTH=${1} 	# 4*2^20 =  64MiB
SEED=42 # was 20181406 before, but was hardcoded to 42 in seqan

output_dir=$OUT_DIR
bin_dir=$output_dir/bins
info_dir=$output_dir/info

mkdir -p $output_dir
mkdir -p $bin_dir
mkdir -p $info_dir

# Simulate reference
echo "Simulating reference of length $LENGTH"
$BINARY_DIR/mason_genome -l $LENGTH -o $bin_dir/ref.fasta -s $SEED


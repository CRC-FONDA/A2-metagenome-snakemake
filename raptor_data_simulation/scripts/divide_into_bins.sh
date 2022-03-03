#!/usr/bin/env bash
set -e

BINARY_DIR=/home/evelia95/raptor_data_simulation/build/bin
OUT_DIR=/home/evelia95/NO_BACKUP/simulated_metagenome
LENGTH=${1} 	# 4*2^20 =  64MiB
SEED=42 # was 20181406 before, but was hardcoded to 42 in seqan
BIN_NUMBER=${2}
HAPLOTYPE_COUNT=${3}

output_dir=$OUT_DIR
bin_dir=$output_dir/bins
info_dir=$output_dir/info

bin_length=$((LENGTH / BIN_NUMBER))

# Evenly distribute it over bins
echo "Splitting genome into $BIN_NUMBER bins with bin_length of $bin_length"
$BINARY_DIR/split_sequence --input $bin_dir/ref.fasta --length $bin_length --parts $BIN_NUMBER
# We do not need the reference anymore
# rm $bin_dir/ref.fasta
# Rename the bins to .fa
for i in $bin_dir/*.fasta; do mv $i $bin_dir/$(basename $i .fasta).fa; done
# Simulate haplotypes for each bin
echo "Generating haplotypes"
for i in $bin_dir/*.fa
do
   $BINARY_DIR/mason_variator \
       -ir $i \
       -n $HAPLOTYPE_COUNT \
       -of $bin_dir/$(basename $i .fa).fasta \
       -ov $info_dir/$(basename $i .fa).vcf 
   # &>/dev/null
   	
   rm $i
   rm $i.fai
done

echo "renaming bin files"
cd $bin_dir
for file in bin_*.fasta; do
	mv "$file" "${file#bin_}";
done;
#for file in 0000[0-9]*.fasta; do
#	mv "$file" "${file#0}";
#done;
for file in 000[0-9]*.fasta; do
	mv "$file" "${file#0}";
done;
for file in 00[0-9]*.fasta; do
	mv "$file" "${file#0}";
done;
for file in 0[0-9]*.fasta; do
	mv "$file" "${file#0}";
done;

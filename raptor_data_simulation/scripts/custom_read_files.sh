#!/bin/bash

p="../data/${1}/${2}/reads_e${3}_${4}"
echo "${p}"
cd $p

rm bin*
rm all_10.fastq

num_files=${5}
echo "Dividing reads into ${num_files} read files"


a=($(wc all.fastq))
total_lines=${a[0]}

# https://stackoverflow.com/questions/7764755/how-to-split-a-file-into-equal-parts-without-breaking-individual-lines
((lines_per_file = (total_lines + num_files - 1) / num_files))

split --lines=${lines_per_file} all.fastq reads_

echo "Total number of reads = $((total_lines / 4))"
echo "Reads per file = $((lines_per_file / 4))"

k=0
for file in reads_*; do
    mv "$file" "$k.fastq"
    ((k++))
done;


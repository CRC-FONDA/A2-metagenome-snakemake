#!/bin/bash

p="../data/${1}/${2}/reads_e${3}_${4}"
echo "${p}"
cd $p

rm bin*
rm all_10.fastq

nr=${5}
echo "dividing reads into ${nr} read files"

split -nr/"${nr}" all.fastq reads_

k=0
for file in reads_*; do
    mv "$file" "$k.fastq"
    ((k++))
done;


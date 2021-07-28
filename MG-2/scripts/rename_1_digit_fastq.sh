#!/bin/bash


p="../simulated_data/reads_e${1}_${2}"
echo "${p}"
cd $p

FILE=bin_0.fastq
if [ -f "$FILE" ]; then
    # file exists
    echo "renaming read files"
    for file in bin_*.fastq; do 
	echo $file;
	mv "$file" "${file#bin_}";
    done;
fi


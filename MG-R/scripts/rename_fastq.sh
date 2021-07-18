#!/bin/bash


p="../simulated_data/reads_e${1}_${2}"
echo "${p}"
cd $p

FILE=bin_00.fastq
if [ -f "$FILE" ]; then
    # file exists
    echo "renaming read files"
    for file in bin_*.fastq; do 
	echo $file;
	mv "$file" "${file#bin_}";
    done;

    for file in 0[0-9].fastq; do
	mv "$file" "${file#0}";
    done;
fi


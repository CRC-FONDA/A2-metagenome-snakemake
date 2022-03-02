#!/bin/bash


p="${1}/${2}/reads"
echo "${p}"
cd $p

FILE="bin_${3}.fastq"
if [ -f "$FILE" ]; then
    # file exists
    echo "renaming read files"
    for file in bin_*.fastq; do 
	mv "$file" "${file#bin_}";
    done;

    for file in 0000[0-9]*.fastq; do
	mv "$file" "${file#0}";
    done;
    for file in 000[0-9]*.fastq; do
	mv "$file" "${file#0}";
    done;
    for file in 00[0-9]*.fastq; do
	mv "$file" "${file#0}";
    done;
    for file in 0[0-9]*.fastq; do
	mv "$file" "${file#0}";
    done;
fi


#!/bin/bash

cd ../simulated_data/bins


FILE=bin_0.fasta
if [ -f "$FILE" ]; then
    echo "renaming bin files"
    for file in bin_*.fasta; do 
	    echo $file;
	    mv "$file" "${file#bin_}";
    done;
fi



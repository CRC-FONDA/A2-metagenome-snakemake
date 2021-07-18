#!/bin/bash

cd ../simulated_data/bins


FILE=bin_00.fasta
if [ -f "$FILE" ]; then
    echo "renaming bin files"
    for file in bin_*.fasta; do 
	    echo $file;
	    mv "$file" "${file#bin_}";
    done;

    for file in 0[0-9].fasta; do
        mv "$file" "${file#0}";
    done;
        echo "$FILE exists."
fi



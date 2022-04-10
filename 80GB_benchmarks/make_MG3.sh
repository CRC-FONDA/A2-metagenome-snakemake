#!/bin/bash

cd redwood/MG3
head -1 fm_0.txt > all_fm.txt; tail -n +2 -q fm_*.txt >> all_fm.txt
head -1 mapped_0.txt > all_mapped.txt; tail -n +2 -q mapped_*.txt >> all_mapped.txt

cd ../../allegro/MG3
head -1 fm_0.txt > all_fm.txt; tail -n +2 -q fm_*.txt >> all_fm.txt
head -1 mapped_0.txt > all_mapped.txt; tail -n +2 -q mapped_*.txt >> all_mapped.txt

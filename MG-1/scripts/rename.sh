#!/bin/bash


for file in dream_out/indices/bin_[0-9].* ; do
	mv "$file" "${file:0:22}0${file:22}" ;
done



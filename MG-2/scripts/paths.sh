#!/bin/bash

path="${PWD}/../data/${1}/bins/*"

echo "Gathering paths from: "
echo "$path"

mkdir -p "metadata"
ls -d $path > "metadata/bin_paths.txt"

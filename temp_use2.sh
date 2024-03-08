#!/bin/bash

folders=()
for dir in */; do
    folders+=("${dir%/}")
done
folder_count=${#folders[@]}
echo "Now you have $folder_count bam files to be transferred."

while [ $folder_count -ge 0 ]; do
    folder_count=$((folder_count - 1))
    echo ""
    echo "We have ${folder_count} bam files need to transfer. Now we are going to transfer the bam file: ${folders[$folder_count]}."
    cd ${folders[$folder_count]}
    cp ${folders[$folder_count]}Aligned.sortedByCoord.out.bam ../../bam
    cd ..
    wait
done


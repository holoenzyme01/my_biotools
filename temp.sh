#!/bin/bash

# Set the directory path
directory="/e:/Xu_lab/rMATS_visualize/"

# Loop through all the files in the directory
for file in "$directory"*.fastq.gz.fastp.fastq.gz; do
    # Get the base name of the file
    base_name=$(basename "$file")

    # Remove the last occurrence of ".fastq.gz" from the base name
    new_name="${base_name%.fastq.gz}"

    # Rename the file
    mv "$file" "$directory$new_name"
done


# 将质控后文件比对到基因组
mkdir ./alignment
cd ./alignment




files_path=$(pwd)
r1_fastq_gz_files_2=$(ls $files_path/*.R1.fastq.gz | xargs -n1 basename | sort)
r2_fastq_gz_files_2=$(ls $files_path/*.R2.fastq.gz | xargs -n1 basename | sort)

r1_files_2=()
r2_files_2=()
for file in $r1_fastq_gz_files_1; do
    r1_files_1+=("$file")
done
for file in $r2_fastq_gz_files_1; do
    r2_files_1+=("$file")
done

for file in $(ls ../fastp_results/*.fastq.gz); do
    echo "Now we are going to do the alignment for the fastq file: $file."
    hisat2 -p 8 -x /path/to/hisat2_index -1 $file -2 ${file%R1*}R2* -S ${file%fastq*}sam
    wait
done
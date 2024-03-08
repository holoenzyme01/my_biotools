#!/bin/bash

files_path=$(pwd)
r1_fastq_gz_files_2=$(ls $files_path/*.R1.fastp.fastq.gz | xargs -n1 basename | sort)
r2_fastq_gz_files_2=$(ls $files_path/*.R2.fastp.fastq.gz | xargs -n1 basename | sort)

r1_files_2=()
r2_files_2=()
for file in $r1_fastq_gz_files_2; do
    r1_files_2+=("$file")
done
for file in $r2_fastq_gz_files_2; do
    r2_files_2+=("$file")
done

file_count_2=${#r1_files_2[@]}
while [ $file_count_2 -ge 0 ]; do
    file_count_2=$((file_count_2 - 1))
    echo ""
    echo "Now we are going to align fastq files: ${r1_files_2[$file_count_2]} and ${r2_files_2[$file_count_2]}."
    mkdir -p ../alignment/${r1_files_2[$file_count_2]}/${r2_files_2[$file_count_2]}
    STAR --runMode alignReads --runThreadN 16 --readFilesCommand zcat --twopassMode Basic  --outSAMtype BAM SortedByCoordinate --outSAMunmapped None --genomeDir /data3/lwd/GENOME_REF/FRUIT_FLY/dmel_r6.56/genome_indices --quantMode GeneCounts --readFilesIn ${r1_files_2[$file_count_2]} ${r2_files_2[$file_count_2]} --outFileNamePrefix ../alignment/${r1_files_2[$file_count_2]}/${r2_files_2[$file_count_2]} --outFilterMismatchNmax 999 --outFilterMismatchNoverLmax 0.04 --outFilterType BySJout --alignSJoverhangMin 8 --alignSJDBoverhangMin 1
    wait
done
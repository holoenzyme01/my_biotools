#!/bin/bash
 
# 第一步，选取文件夹中的gz文件
files_path=$(pwd)
r1_fastq_gz_files_1=$(ls $files_path/*.R1.fastq.gz | xargs -n1 basename | sort)
r2_fastq_gz_files_1=$(ls $files_path/*.R2.fastq.gz | xargs -n1 basename | sort)

# 将文件写入到列表中
r1_files_1=()
r2_files_1=()
for file in $r1_fastq_gz_files_1; do
    r1_files_1+=("$file")
done
for file in $r2_fastq_gz_files_1; do
    r2_files_1+=("$file")
done

# 检查两个列表中的文件数目是否相等
if [ ${#r1_files_1[@]} -eq ${#r2_files_1[@]} ]; then
    file_count=${#r1_files_1[@]}
    echo "The number of files in r1_files and r2_files is equal. The number of the file is: $file_count"
else
    echo "The number of files in r1_files and r2_files is not equal."
    exit_flag = 1
fi

# fastp质控结果输出
mkdir ./fastp_results
while [ $file_count -ge 0 ]; do
    file_count=$((file_count - 1))
    echo ""
    echo "Now we are going to do the quality control for the fastq files: ${r1_files_1[$file_count]} and ${r2_files_1[$file_count]}."
    fastp -w 16 -i ${r1_files_1[$file_count]} -I ${r2_files_1[$file_count]} -o ./fastp_results/${r1_files_1[$file_count]}.fastp.fastq.gz -O ./fastp_results/${r2_files_1[$file_count]}.fastp.fastq.gz -h ./fastp_results/${r1_files_1[$file_count]}.fastp.html -j ./fastp_results/${r1_files_1[$file_count]}.fastp.json
    wait
done

# 简化文件名
cd ./fastp_results
for file in *.fastq.gz.fastp.fastq.gz; do
    mv "$file" "${file%.fastq.gz.fastp.fastq.gz}.fastp.fastq.gz"
done
cd ..

# 结束
echo ""
echo "The quality control for the fastq files is done. You can see the results in the ${files_path}/fastp_results folder."
echo ""



# 第二步，将质控后文件比对到基因组
mkdir ./alignment
cd ./fastp_results
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

# 结束
echo "The alignment for the fastq files is done. You can see the results in the ${files_path}/alignment folder."
echo ""
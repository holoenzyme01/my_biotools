#!/bin/bash
 
# 第一步，选取文件夹中的gz文件
files_path=$(pwd)
r1_fastq_gz_files=$(ls $files_path/*.R1.fastq.gz | xargs -n1 basename | sort)
r2_fastq_gz_files=$(ls $files_path/*.R2.fastq.gz | xargs -n1 basename | sort)

# 将文件写入到列表中
r1_files=()
r2_files=()
for file in $r1_fastq_gz_files; do
    r1_files+=("$file")
done
for file in $r2_fastq_gz_files; do
    r2_files+=("$file")
done

# 检查两个列表中的文件数目是否相等
if [ ${#r1_files[@]} -eq ${#r2_files[@]} ]; then
    file_count=${#r1_files[@]}
    echo "The number of files in r1_files and r2_files is equal. The number of the file is: $file_count"
else
    echo "The number of files in r1_files and r2_files is not equal."
    exit_flag = 1
fi

# fastp质控结果输出
mkdir ./fastp_results
while [ $file_count -ge 0 ]; do
    echo "Now we are going to do the quality control for the fastq files: ${r1_files[$file_count]} and ${r2_files[$file_count]}."
    fastp -i ${r1_files[$file_count]} -I ${r2_files[$file_count]} -o ./fastp_results/${r1_files[$file_count]}.fastp.fastq.gz -O ./fastp_results/${r2_files[$file_count]}.fastp.fastq.gz -h ./fastp_results/${r1_files[$file_count]}.fastp.html -j ./fastp_results/${r1_files[$file_count]}.fastp.json
    wait
    file_count=$((file_count - 1))
done

# 结束
echo "The quality control for the fastq files is done. You can see the results in the ${pwd}/fastp_results folder."

#!/bin/bash
 
# 该文件和count_spacers.py文件在同一目录下，输出文件则在该目录的/output文件夹下
# 文库的信息在lib_ab.csv文件中，仅需要spacer序列即可

# 第零步，将gz文件解压缩
files_path=$(pwd)
fastq_gz_files=$(ls $files_path/*.fastq.gz | xargs -n1 basename | sort)
for file in $fastq_gz_files; do
    gunzip -c $file > ${file%.fastq.gz}.fastq
done

echo "All the files have been unzipped!"

# 第一步，根据count_spacers.py文件统计spacer序列counts

fastq_files=$(ls $files_path/*R1.fastq | xargs -n1 basename | sort)
mkdir ./count_table
for file in $fastq_files; do
    python count_spacers.py -f $file -o ${file}.out.csv -i lib_ab.csv
    mv ${file}.out.csv ./count_table
done

echo "All the spacer counts have been calculated, and move to the ./count_table folder!"

# 将count_table.csv文件合并
# 由于Genome-scale CRISPR-Cas9 knockout and transcriptional activation screening文章中的Step 65-69中的“RIGER is launched through GENE-E”中的GENE-E软件无法下载，
#   所以这里只是将count_table.csv文件合并，后续的分析在MAGeCK中进行
#!/bin/bash
 
genome_path = "/data3/lwd/GENOME_REF/FRUIT_FLY/dmel_r6.56/genome_indices"

# 针对双端测序文件进行的比较



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
    mkdir -p ../alignment/${r1_files_2[$file_count_2]}/${r1_files_2[$file_count_2]}
    STAR --runMode alignReads --runThreadN 16 --readFilesCommand zcat --twopassMode Basic  --outSAMtype BAM SortedByCoordinate --outSAMunmapped None --genomeDir $genome_path --quantMode GeneCounts --readFilesIn ${r1_files_2[$file_count_2]} ${r2_files_2[$file_count_2]} --outFileNamePrefix ../alignment/${r1_files_2[$file_count_2]}/${r1_files_2[$file_count_2]} --outFilterMismatchNmax 999 --outFilterMismatchNoverLmax 0.04 --outFilterType BySJout --alignSJoverhangMin 8 --alignSJDBoverhangMin 1
    wait
done

cd ../alignment

# 第三步，转移bam文件至bam文件夹中
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
echo "The bam files have been transferred to the /bam folder."

# 使用featureCounts进行基因计数
nohup featureCounts -T 16 -p -t exon -g gene_id -a /data3/lwd/GENOME_REF/FRUIT_FLY/dmel_r6.56/dmel-all-r6.56.gtf -o all-1.txt A-1_L2_UDI012.R1.fastp.fastq.gzAligned.sortedByCoord.out.bam A-2_L2_UDI013.R1.fastp.fastq.gzAligned.sortedByCoord.out.bam A-3_L2_UDI014.R1.fastp.fastq.gzAligned.sortedByCoord.out.bam B-1_L2_UDI296.R1.fastp.fastq.gzAligned.sortedByCoord.out.bam B-2_L2_UDI016.R1.fastp.fastq.gzAligned.sortedByCoord.out.bam B-3_L2_UDI017.R1.fastp.fastq.gzAligned.sortedByCoord.out.bam C-1_L2_UDI018.R1.fastp.fastq.gzAligned.sortedByCoord.out.bam C-2_L2_UDI019.R1.fastp.fastq.gzAligned.sortedByCoord.out.bam C-3_L2_UDI020.R1.fastp.fastq.gzAligned.sortedByCoord.out.bam D-1_L2_UDI021.R1.fastp.fastq.gzAligned.sortedByCoord.out.bam D-2_L2_UDI022.R1.fastp.fastq.gzAligned.sortedByCoord.out.bam D-3_L2_UDI023.R1.fastp.fastq.gzAligned.sortedByCoord.out.bam > featurecount.out &
cut -f 1,7,8,9,10,11,12,13,14,15,16,17,18 all.txt | grep -v '^#' >feacturCounts.txt
sed 's/ /,/g' all-1.txt > all1.txt


# 结束
echo ""
echo "The alignment for the fastq files is done. You can see the results in the /alignment folder, and bam files in the /bam folder. :)"
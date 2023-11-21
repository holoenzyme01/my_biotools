#!/bin/bash

# 针对两个文件的分析，需要进一步改进，根据提交sample的数目进行修正

files_path=$(pwd)
files=$(ls $files_path)

echo "Clean principle: 1.FDR>=0.05; 2.From one sample, the reads must >=5"

for file in $files
do
echo "$file is analysising"
	case "$file" in 
	
	"A3SS.MATS.JC.txt")
		awk ' $20 < 0.05 {print $2,$13,$14,$15,$16,$23}' $file | awk ' {split ($2,a,",");split ($3,b,",");split ($4,c,",");split ($5,d,",");print $1,a[1],a[2],b[1],b[2],c[1],c[2],d[1],d[2],$6}' | awk '{if ( $2+$3+$4+$5>=5 || $6+$7+$8+$9>=5 ) print $1,$10}' | awk '{$1="A3SS\t"$1}1 {print $0}' | awk '{gsub(/ /,"\t"); print}' > A3SS_clean.out
		printf " \n"
		;;
	"A5SS.MATS.JC.txt")
		awk ' $20 < 0.05 {print $2,$13,$14,$15,$16,$23}' $file | awk ' {split ($2,a,",");split ($3,b,",");split ($4,c,",");split ($5,d,",");print $1,a[1],a[2],b[1],b[2],c[1],c[2],d[1],d[2],$6}' | awk '{if ( $2+$3+$4+$5>=5 || $6+$7+$8+$9>=5 ) print $1,$10}' | awk '{$1="A5SS\t"$1}1 {print $0}' | awk '{gsub(/ /,"\t"); print}' > A5SS_clean.out
		printf " \n"
		;;
	"MXE.MATS.JC.txt")
		awk ' $22 < 0.05 {print $2,$15,$16,$17,$18,$25}' $file | awk ' {split ($2,a,",");split ($3,b,",");split ($4,c,",");split ($5,d,",");print $1,a[1],a[2],b[1],b[2],c[1],c[2],d[1],d[2],$6}' | awk '{if ( $2+$3+$4+$5>=5 || $6+$7+$8+$9>=5 ) print $1,$10}' | awk '{$1="MXE\t"$1}1 {print $0}' | awk '{gsub(/ /,"\t"); print}'> MXE_clean.out
		printf " \n"
		;;
	"RI.MATS.JC.txt")
		awk ' $20 < 0.05 {print $2,$13,$14,$15,$16,$23}' $file | awk ' {split ($2,a,",");split ($3,b,",");split ($4,c,",");split ($5,d,",");print $1,a[1],a[2],b[1],b[2],c[1],c[2],d[1],d[2],$6}' | awk '{if ( $2+$3+$4+$5>=5 || $6+$7+$8+$9>=5 ) print $1,$10}' | awk '{$1="RI\t"$1}1 {print $0}' | awk '{gsub(/ /,"\t"); print}'> RI_clean.out
		printf " \n"
		;;
	"SE.MATS.JC.txt")
		awk ' $20 < 0.05 {print $2,$13,$14,$15,$16,$23}' $file | awk ' {split ($2,a,",");split ($3,b,",");split ($4,c,",");split ($5,d,",");print $1,a[1],a[2],b[1],b[2],c[1],c[2],d[1],d[2],$6}' | awk '{if ( $2+$3+$4+$5>=5 || $6+$7+$8+$9>=5 ) print $1,$10}' | awk '{$1="SE\t"$1}1 {print $0}' | awk '{gsub(/ /,"\t"); print}'> SE_clean.out
		printf " \n"
		;;
	*)
		echo "Unknown file: $file"
		printf " \n"
		;;
	esac
done
cat A3SS_clean.out A5SS_clean.out MXE_clean.out RI_clean.out SE_clean.out > All_clean.out
awk '{print $1,$3}' All_clean.out | awk '{gsub(/ /,"\t"); print}' > All_clean_with_two_line.out
echo "Complete analysis! You can find the splicing event and gene name with FDR in All_clean.out. Two line results contain splicing event" 

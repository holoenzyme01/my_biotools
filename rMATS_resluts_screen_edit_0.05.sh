#!/bin/bash

files_path=$(pwd)
files=$(ls $files_path)

echo "Clean principle: 1.FDR>=0.05"

for file in $files
do
echo "$file is analysising"
	case "$file" in 
	
	"A3SS.MATS.JC.txt")
		awk ' $20 < 0.05 {print $2,$20,$23}' $file | awk '( $3 > 0.05 || $3 < -0.05 ) {print $1,$3}' | awk '{$1="A3SS\t"$1}1 {print $0}' | awk '{gsub(/ /,"\t"); print}' > A3SS_clean.out
		printf " \n"
		;;
	"A5SS.MATS.JC.txt")
		awk ' $20 < 0.05 {print $2,$20,$23}' $file | awk '( $3 > 0.05 || $3 < -0.05 ) {print $1,$3}' | awk '{$1="A5SS\t"$1}1 {print $0}' | awk '{gsub(/ /,"\t"); print}'  > A5SS_clean.out
		printf " \n"
		;;
	"MXE.MATS.JC.txt")
		awk ' $22 < 0.05 {print $2,$22,$25}' $file | awk '( $3 > 0.05 || $3 < -0.05 ) {print $1,$3}' | awk '{$1="MXE\t"$1}1 {print $0}' | awk '{gsub(/ /,"\t"); print}'  > MXE_clean.out
		printf " \n"
		;;
	"RI.MATS.JC.txt")
		awk ' $20 < 0.05 {print $2,$20,$23}' $file | awk '( $3 > 0.05 || $3 < -0.05 ) {print $1,$3}' | awk '{$1="RI\t"$1}1 {print $0}' | awk '{gsub(/ /,"\t"); print}' > RI_clean.out
		printf " \n"
		;;
	"SE.MATS.JC.txt")
		awk ' $20 < 0.05 {print $2,$20,$23}' $file | awk '( $3 > 0.05 || $3 < -0.05 ) {print $1,$3}' | awk '{$1="SE\t"$1}1 {print $0}' | awk '{gsub(/ /,"\t"); print}' > SE_clean.out
		printf " \n"
		;;
	*)
		echo "Unknown file: $file"
		printf " \n"
		;;
	esac
done
cat A3SS_clean.out A5SS_clean.out MXE_clean.out RI_clean.out SE_clean.out > All_clean_0.05.out
echo "Complete analysis! You can find the splicing event and gene name with FDR in All_clean.out. Two line results contain splicing event" 

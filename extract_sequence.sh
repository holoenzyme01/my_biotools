# 提取exon和基因的位置信息，不包括线粒体基因
cat Saccharomyces_cerevisiae.R64-1-1.59.gtf | awk 'BEGIN{FS=OFS="\t"} $3=="exon" && $1!="Mito" {split($9,a,"\""); print $1,$4-1, $5, a[2]}' | sort -k1,1 -k2,2n > SC.exon.table
cat Saccharomyces_cerevisiae.R64-1-1.59.gtf | awk 'BEGIN{FS=OFS="\t"} $3=="exon" && $1!="Mito" {split($9,a,"\""); print $1,$4-1, $5, a[2]}' | sort -k1,1 -k2,2n | bedtools merge > SC.exon.bedtools.merge.bed

cat Saccharomyces_cerevisiae.R64-1-1.59.gtf | awk 'BEGIN{FS=OFS="\t"} $3=="gene"&& $1!="Mito" {split($9,a,"\""); print $1,$4-1, $5, a[2]}' | sort -k1,1V -k2,2n > SC.gene.sort.bed
cat Saccharomyces_cerevisiae.R64-1-1.59.gtf | awk 'BEGIN{FS=OFS="\t"} $3=="gene" && $1!="Mito" {split($9,a,"\""); print $1,$4-1, $5, a[2]}' | sort -k1,1 -k2,2n | bedtools merge > SC.gene.bedtools.merge.bed

# 提取intron
bedtools subtract -a SC.gene.bedtools.merge.bed -b SC.exon.bedtools.merge.bed | sort -k1,1 -k2,2n  > SC.intron.bed

cat saccharomyces_cerevisiae_R64-4-1_20230830.gff | grep -v 'Uncharacterized' | awk 'BEGIN{OFS=FS="\t"} $3=="intron" && $1!="chrmt" {print $1,$4-1,$5}' |wc -l

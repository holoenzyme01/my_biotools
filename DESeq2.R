countData_F <- read.csv("countData.csv", row.names = 1)
condition <- factor(c(rep("WT",3),rep("KO",3)),levels = c("WT","KO"))
colData <- data.frame(row.names = colnames(countData_F),conditions=condition)
dds <- DESeqDataSetFromMatrix(countData_F, colData, design = ~ conditions)
dds <- DESeq(dds)
res <- results(dds)

diff.table <- subset(res, padj <= 0.05)
write.table(diff.table,"WT_VS_KO", sep='\t', row.names = T, quote = F)
diff_exp <- read.table("WT_VS_KO", sep='\t', header = T,row.names = 1)
diff_exp <- diff_exp[,c(2,5)]
diff_exp <- mutate(diff_exp, log10pvalue = log10(diff_exp$pvalue))
diff_exp$change <- ifelse(diff_exp$log2FoldChange > 1, "up", ifelse(diff_exp$log2FoldChange < -1, "down", "stable"))

up.table <- subset(res, padj <= 0.05 & log2FoldChange >= 1)
write.table(up.table,"WT_VS_KO_up", sep='\t', row.names = T, quote = F)
up_exp <- read.table("WT_VS_KO_up", sep='\t', header = T,row.names = 1)
up_exp <- up_exp[,c(2,5)]
up_exp <- mutate(up_exp, log10pvalue = log10(up_exp$pvalue))

down.table <- subset(res, padj <= 0.05 & log2FoldChange <= -1)
write.table(down.table,"WT_VS_KO_down", sep='\t', row.names = T, quote = F)
down_exp <- read.table("WT_VS_KO_down", sep='\t', header = T,row.names = 1)
down_exp <- down_exp[,c(2,5)]
down_exp <- mutate(down_exp, log10pvalue = log10(down_exp$pvalue))

print(paste('差异基因数量: ', nrow(diff.table)))
print(paste('显著差异上调基因数量: ', nrow(up.table) + nrow(down.table)))
print(paste('显著差异上调基因数量: ', nrow(up.table)))
print(paste('显著差异下调基因数量: ', nrow(down.table)))


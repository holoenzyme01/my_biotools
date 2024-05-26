# 此处的countData_F是单独的一组数据，需要根据实际情况进行修改，一次只能计算一组数据
countData_F <- read.csv("countData.csv", row.names = 1)
condition <- factor(c(rep("WT",3),rep("KO",3)),levels = c("WT","KO"))
colData <- data.frame(row.names = colnames(countData_F),conditions=condition)
dds <- DESeqDataSetFromMatrix(countData_F, colData, design = ~ conditions)
dds <- DESeq(dds)
res <- results(dds)

diff.table <- subset(res, padj <= 0.05 & abs(log2FoldChange) >= 1)
write.table(diff.table,"KO_VS_WT.csv", sep='\t', row.names = T, quote = F)
diff_exp <- read.table("KO_VS_WT.csv", sep='\t', header = T,row.names = 1)
diff_exp <- diff_exp[,c(2,5)]
diff_exp <- mutate(diff_exp, log10pvalue = log10(diff_exp$pvalue))

up.table <- subset(res, padj <= 0.05 & log2FoldChange >= 1)
write.table(up.table,"KO_VS_WT_up.csv", sep='\t', row.names = T, quote = F)
up_exp <- read.table("KO_VS_WT_up.csv", sep='\t', header = T,row.names = 1)
up_exp <- up_exp[,c(2,5)]
up_exp <- mutate(up_exp, log10pvalue = log10(up_exp$pvalue))

down.table <- subset(res, padj <= 0.05 & log2FoldChange <= -1)
write.table(down.table,"KO_VS_WT_down.csv", sep='\t', row.names = T, quote = F)
down_exp <- read.table("KO_VS_WT_down.csv", sep='\t', header = T,row.names = 1)
down_exp <- down_exp[,c(2,5)]
down_exp <- mutate(down_exp, log10pvalue = log10(down_exp$pvalue))

print(paste('KO_VS_WT差异基因数量: ', nrow(diff.table)))
print(paste('KO_VS_WT显著差异基因数量: ', nrow(up.table) + nrow(down.table)))
print(paste('KO_VS_WT差异上调基因数量: ', nrow(up.table)))
print(paste('KO_VS_WT差异下调基因数量: ', nrow(down.table)))


diff_exp$change <- ifelse(diff_exp$log2FoldChange > 1, "up",
                          ifelse(diff_exp$log2FoldChange < -1, "down", "stable"))

ggplot(diff_exp, aes(x = log2FoldChange, y = -log10pvalue, colour = change)) +
  geom_point(alpha=0.7, size = 1) +
  scale_color_manual(values=c("blue", "gray","red")) + 
  ggtitle("Female KO vs WT") +
  labs(x = "log2FoldChange", y = "-log10(pvalue)") +
  geom_vline(aes(xintercept=1), colour="black", linetype="dashed", size = 0.4) +
  geom_vline(aes(xintercept=-1), colour="black", linetype="dashed", size = 0.4) +
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5), 
        legend.position="right",
        legend.title = element_blank())

  


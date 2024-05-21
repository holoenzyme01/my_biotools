个人使用，小小小代码量，低低低coding水平
目前的功能
1. rMATs_visualize (基本完成)
2. GO anlysis (基本完成)
3. Extract specific sequence from genome based on gtf file (正在进行)

# 2024.05.18
觉得仅仅是rMATs的可视化分析内容有些太少了，准备把整个项目进行修改，最终的目标是锁定在自己在日常使用的生信代码上面

# 2024.05.08
突然打开看了看，把绘制表达矩阵和GO富集分析的内容加上去了
此处感谢互联网，gpt以及sbz提供的指导

# 2024.03.13更新
完成了（没有）从bam获得表达矩阵，将脚本从From_fastq_to_bam.sh更改为From_fastq_to_exp_martix.sh
使用featureCounts获得表达矩阵，参数为默认参数
只是添加了命令内容，并不能自动化完成
另外，添加了DESeq2的脚本命令，也不能自动化
先做个保存，具体实现就后面再说

# 2024.03.08更新
完成了从fastq.gz到bam的全流程自动化，脚本为From_fastq_to_bam.sh
其中，fastp参数为：
- -w 16
STAR参数为：
- --runMode alignReads
- --runThreadN 16
- --readFilesCommand zcat
- --twopassMode Basic
- --outSAMtype BAM SortedByCoordinate
- --outSAMunmapped None
- --outFilterMismatchNmax 999
- --outFilterMismatchNoverLmax 0.04 
- --outFilterType BySJout
- --alignSJoverhangMin 8
- --alignSJDBoverhangMin 1

运行结束后fastp结果在/fastp_results中，STAR比对文件在/alignment中，STAR比对的bam结果在/bam中

整个流程听取了hqw，lsb和lam师兄的建议，也参考了互联网的内容，还有copilot的代码参考（太好用了真的）
STAR参数参考了hqw师兄的建议
在此表示万分感谢 :)

# 2024.03.07更新
对于文件夹内的转录组数据，使用fastp进行质检
质检后进行STAR比对
(需要提前修改文件中的基因组位置信息等内容)

# 2024.01.09更新
简化了一下筛选，直接根据FDR0.05和0.1进行筛选然后输出结果

# 11.21更新
分析筛选rMATS的结果，算是可以用吧，还需要进一步修正

# 下一步计划：

- 针对不同的sample数目可以进行识别和调整
- 补充后续R的代码

# 最终目标

实现fastq到可变剪切可视化的全自动代码流程（或者仅需微调一些参数）
💪

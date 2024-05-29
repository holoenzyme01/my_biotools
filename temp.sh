import pandas as pd
 
df1 = pd.read_csv(Kong1_S17_R1.fastq.out.csv)
df2 = pd.read_csv(Kong1_S1_R1.fastq.out.csv)
df3 = pd.read_csv(Kong2_S19_R1.fastq.out.csv)
df4 = pd.read_csv(Kong2_S3_R1.fastq.out.csv)
df5 = pd.read_csv(Kong3_S20_R1.fastq.out.csv)
df6 = pd.read_csv(Kong3_S5_R1.fastq.out.csv)
df7 = pd.read_csv(L1_S16_R1.fastq.out.csv)
df8 = pd.read_csv(L2_S19_R1.fastq.out.csv)
df9 = pd.read_csv(L3_S10_R1.fastq.out.csv)
df10 = pd.read_csv(N1_S2_R1.fastq.out.csv)
df11 = pd.read_csv(N2_S4_R1.fastq.out.csv)
df12 = pd.read_csv(N3_S6_R1.fastq.out.csv)
df13 = pd.read_csv(O1_S8_R1.fastq.out.csv)
df14 = pd.read_csv(O2_S11_R1.fastq.out.csv)
df15 = pd.read_csv(O3_S13_R1.fastq.out.csv)
df16 = pd.read_csv(Q1_S9_R1.fastq.out.csv)
df17 = pd.read_csv(Q2_S12_R1.fastq.out.csv)
df18 = pd.read_csv(Q3_S14_R1.fastq.out.csv)

 
file = [df1, df2, df3, df4, df5, df6, df7, df8, df9, df10, df11, df12, df13, df14, df15, df16, df17, df18]
 
outfile = pd.concat(file, axis=1) #横着拼接
 
outfile.to_csv(index=0, sep=',') #输出文件名NegativeYH
 
print(outfile.shape) #查看文件大小
# 基础设置
folder_path <- read_file("./path.txt")
count_tables_file_Names <- list.files(folder_path)

# 读取count_table
count_table <- list()
for (i in seq_along(count_tables_file_Names)) {
  count_table[[i]] <- read_csv(count_tables_file_Names[i], col_names = c("spacer","counts"))
}

#  数据表的合并
count_table <- reduce(count_table, full_join, by = "spacer")
cleaned_file_names <- sub("\\.fastq\\.out\\.csv$", "", count_tables_file_Names) # 清理多余的后缀
colnames(count_table) <- c("spacer", cleaned_file_names)

# 合并后表格导出
write_csv(count_table, "./count_table/all_count_table.csv")

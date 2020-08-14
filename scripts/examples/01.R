library(arrow)

issues <- read_parquet("../../data_msr/issues_fixed.parquet")
plot(table(strftime(issues$created, "%Y")))

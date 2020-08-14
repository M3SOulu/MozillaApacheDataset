library(arrow)

dir.in <- "."
dir.out <- "."

files <- dir(dir.in, pattern="\\.parquet$", recursive=TRUE)

Parquet2CSV <- function(file.in, dir.in, dir.out, compression=TRUE) {
  message("Reading ", file.path(dir.in, file.in))
  data <- read_parquet(file.path(dir.in, file.in))
  file.ext <- if (compression) "csv.gz" else "csv"
  file.out <- file.path(dir.out, sub("parquet$", file.ext, file.in))
  message("Writing ", file.out)
  if (compression) file.out <- gzfile(file.out)
  write.csv(data, file.out)
}

lapply(files, Parquet2CSV, dir.in, dir.out)

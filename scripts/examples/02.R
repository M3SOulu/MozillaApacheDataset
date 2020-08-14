library(arrow)

timestamps <- read_parquet("../../data_msr/timestamps_fixed.parquet")
timestamps <- timestamps[!is.na(timestamps$tz), ]

LocalTime <- function(time, tz) {
  tz <- as.numeric(substr(tz, 1, 3)) + as.numeric(substr(tz, 4, 5)) / 60
  time + as.difftime(tz, units="hours")
}
timestamps$local.time <- LocalTime(timestamps$time, timestamps$tz)

hours <- strftime(timestamps$local.time, "%H")
plot(prop.table(table(hours)))

library(stringr)
library(purrr)
library(lubridate)

get_tail <- function(file) {
  system(paste("tail", file, "-n 1"), intern = TRUE)
}

tails <- dir(file.path("output", "logs"), recursive = TRUE, full.names = TRUE) |> 
  str_subset(".*log$") |> 
  map(get_tail)
  
heads <- dir(file.path("output", "logs"), recursive = TRUE, full.names = TRUE) |> 
  str_subset(".*log$") |> 
  map(readLines, n = 1)

start <- heads |> 
  unlist() |> 
  str_extract(".*\\d{2}:\\d{2}:\\d{2}") |> 
  as_datetime() |> 
  min()

end <- tails |> 
  unlist() |> 
  str_extract(".*\\d{2}:\\d{2}:\\d{2}") |> 
  as_datetime() |> 
  max()

end - start

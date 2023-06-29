suppressPackageStartupMessages({
  library(stringr)
  library(purrr)
})

args <- commandArgs(trailingOnly = TRUE)

n_runs <- as.numeric(args[1])

prop <- dir(file.path("output", "logs"), recursive = TRUE, full.names = TRUE) |> 
  str_subset(".*txt$") |> 
  map(readLines) |> 
  map(str_subset, ".*seed.*") |> 
  map(~length(.x)/n_runs) |> 
  unlist() |> 
  mean()

cat("Percent complete:", sprintf("%.1f%%", prop * 100))

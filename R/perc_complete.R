#!/usr/bin/env Rscript --vanilla

suppressPackageStartupMessages({
  library(stringr)
  library(purrr)
})

args <- commandArgs(trailingOnly = TRUE)

if (length(args) > 0) {
  n_runs <- as.numeric(args[1])
} else if (exists("n_runs_env")) {
  n_runs <- n_runs_env
} else {
  n_runs <- input("How many runs?")
}

prop <- dir(file.path("output", "logs"), recursive = TRUE, full.names = TRUE) |> 
  str_subset(".*txt$") |> 
  map(readLines) |> 
  map(str_subset, ".*seed.*") |> 
  map(~length(.x)/n_runs) |> 
  unlist() |> 
  mean()

cat("Percent complete:", sprintf("%.1f%%", prop * 100), "\n")

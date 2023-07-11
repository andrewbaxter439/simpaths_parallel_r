# do it file-by-file ------------------------------------------------------
library(tidyverse)
library(arrow)
library(furrr)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
    dir_out <- readline("Output directory `out_data/...`:\n")
} else {
    dir_out <- args[1]
}

plan(multicore, workers = 5)

out_dir <- file.path("out_data", dir_out)

person_files <- dir(
  "output",
  full.names = TRUE,
  recursive = TRUE,
  include.dirs = FALSE
) |> 
  str_subset("_\\d+00.*Person\\.csv") |> 
  set_names(nm = ~str_extract(.x, "(?<=\\d{8}_)\\d+00"))


future_imap(
  person_files,
  function(file, seed) {
    read_csv_arrow(file, col_select = -last_col()) |> 
      mutate(run = run + as.integer(seed) - 1) |> 
      group_by(run) |> 
      write_dataset(file.path(out_dir, "person"))
  }
)

household_files <- dir(
  "output",
  full.names = TRUE,
  recursive = TRUE,
  include.dirs = FALSE
) |> 
  str_subset("_\\d+00.*Household\\.csv") |> 
  set_names(nm = ~str_extract(.x, "(?<=\\d{8}_)\\d+00"))


future_imap(
  household_files,
  function(file, seed) {
    read_csv_arrow(file, col_select = -last_col()) |> 
      mutate(run = run + as.integer(seed) - 1) |> 
      group_by(run) |> 
      write_dataset(file.path(out_dir, "household"))
  }
)

benefitunit_files <- dir(
  "output",
  full.names = TRUE,
  recursive = TRUE,
  include.dirs = FALSE
) |> 
  str_subset("_\\d+00.*BenefitUnit\\.csv") |> 
  set_names(nm = ~str_extract(.x, "(?<=\\d{8}_)\\d+00"))


future_imap(
  benefitunit_files,
  function(file, seed) {
    read_csv_arrow(file, col_select = -last_col()) |> 
      mutate(run = run + as.integer(seed) - 1) |> 
      group_by(run) |> 
      write_dataset(file.path(out_dir, "benefitunit"))
  }
)

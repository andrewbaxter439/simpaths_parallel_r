# library(tidyverse)
# library(arrow)
# 
# sim_pops <- dir(
#   "output",
#   full.names = TRUE,
#   recursive = TRUE,
#   include.dirs = FALSE
# ) |> 
#   str_subset("_\\d+00.*Person\\.csv") |> 
#   set_names(nm = ~str_extract(.x, "(?<=\\d{8}_)\\d+00")) |> 
#   map(read_csv_arrow, col_select = -last_col())
# 
# 
# sim_pops[[1]] |> names()
# 
# 
# all_runs <- sim_pops |> 
#   imap(~ 
#          .x |> 
#          mutate(
#            run = run + as.integer(.y) - 1
#   )) |> 
#   reduce(bind_rows)
# 
# out_dir <- file.path("out_data", "test_run")
# 
# all_runs |> 
#   group_by(run) |> 
#   write_dataset(out_dir)



# do it file-by-file ------------------------------------------------------
library(tidyverse)
library(arrow)
library(furrr)

plan(multicore, workers = 20)

out_dir <- file.path("out_data", "test_run")

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
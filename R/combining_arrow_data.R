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

out_dir <- file.path("out_data", dir_out, "combined_data")

person_files <- dir(
  "output",
  full.names = TRUE,
  recursive = TRUE,
  pattern = "Person\\.csv$",
  include.dirs = FALSE
) |>
  set_names(nm = ~ str_extract(.x, "(?<=\\d{8}_)\\d+00"))

benefitunit_files <- dir(
  "output",
  full.names = TRUE,
  recursive = TRUE,
  pattern = "BenefitUnit\\.csv$",
  include.dirs = FALSE
) |>
  set_names(nm = ~ str_extract(.x, "(?<=\\d{8}_)\\d+00"))

person_files |>
  future_imap(\(p_file, seed) {
    d_person <- read_csv_arrow(
      p_file,
      col_select = c(
        run,
        time,
        id_Person,
        idBenefitUnit,
        id_original,
        dhe,
        starts_with("dhm"),
        les_c4,
        labourSupplyWeekly,
        dgn,
        dag,
        deh_c3
      )
    )
    
    d_bu <- read_csv_arrow(
      benefitunit_files[seed],
      col_select = c(
        run,
        time,
        id_BenefitUnit,
        atRiskOfPoverty,
        equivalisedDisposableIncomeYearly,
        starts_with("n_children"),
        region,
        ydses_c5
      )
    )
    
    gc()

    left_join(
      d_person,
      d_bu,
      by = join_by(run, time, idBenefitUnit == id_BenefitUnit)
    ) |> 
      mutate(run = run + as.integer(seed) - 1) |>
  group_by(run) |>
  write_dataset(out_dir)
    
  })


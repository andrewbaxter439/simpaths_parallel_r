library(tidyverse)
library(arrow)
library(furrr)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  dir_out <- readline("Output directory `out_data/...`:\n")
} else if (length(args) == 2){
  dir_out <- args[1]
  dir_in <- args[2]
} else {
  dir_out <- args[1]
  dir_in <- "output"
}

plan(multicore, workers = 5)

out_dir <- file.path("out_data", dir_out, "combined_data")

person_files <- dir(
  dir_in,
  full.names = TRUE,
  recursive = TRUE,
  pattern = "Person\\.csv$",
  include.dirs = FALSE
) |>
  set_names(nm = ~ str_extract(.x, "(?<=\\d{8}_)\\d+00"))

benefitunit_files <- dir(
  dir_in,
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
    
    left_join(d_person,
              d_bu,
              by = join_by(run, time, idBenefitUnit == id_BenefitUnit)) |>
      mutate(run = run + as.integer(seed) - 1) |>
      group_by(run, time) |>
      write_dataset(out_dir)
    
  })

# alt mini-batching -------------------------------------------------------
### A good deal slower - only for use if RAM is tight
# library(tidyverse)
# library(arrow)
# library(furrr)
# library(data.table)
# 
# out_dir <- file.path("out_data", "new_test", "combined_data")
# 
# person_files <- dir(
#   "output",
#   full.names = TRUE,
#   recursive = TRUE,
#   pattern = "Person\\.csv$",
#   include.dirs = FALSE
# ) |>
#   set_names(nm = ~ str_extract(.x, "(?<=\\d{8}_)\\d+00"))
# 
# benefitunit_files <- dir(
#   "output",
#   full.names = TRUE,
#   recursive = TRUE,
#   pattern = "BenefitUnit\\.csv$",
#   include.dirs = FALSE
# ) |>
#   set_names(nm = ~ str_extract(.x, "(?<=\\d{8}_)\\d+00"))
# 
# 
# person_files |>
#   future_imap(\(p_file, seed) {
#     map(1:3, \(run_id) {
#       in_data_person_run_x <- fread(
#         cmd = paste0('grep -E "^run|^', run_id, '," ', person_files[seed]),
#         select = c(
#           "run",
#           "time",
#           "id_Person",
#           "idBenefitUnit",
#           "id_original",
#           "dhe",
#           "dhm",
#           "dhm_ghq",
#           "les_c4",
#           "labourSupplyWeekly",
#           "dgn",
#           "dag",
#           "deh_c3"
#         )
#       )
#       
#       in_data_bu_run_x <- fread(
#         cmd = paste0('grep -E "^run|^', run_id, '," ', benefitunit_files[seed]),
#         select = c(
#           "run",
#           "time",
#           "id_BenefitUnit",
#           "atRiskOfPoverty",
#           "equivalisedDisposableIncomeYearly",
#           "n_children_0",
#           "n_children_1",
#           "n_children_10",
#           "n_children_11",
#           "n_children_12",
#           "n_children_13",
#           "n_children_14",
#           "n_children_15",
#           "n_children_16",
#           "n_children_17",
#           "n_children_2",
#           "n_children_3",
#           "n_children_4",
#           "n_children_5",
#           "n_children_6",
#           "n_children_7",
#           "n_children_8",
#           "n_children_9",
#           "region",
#           "ydses_c5"
#         )
#       )
#       
#       in_data_person_run_x[,run := run + as.integer(seed) - 1]
#       in_data_pbu_run_1[,run := run + as.integer(seed) - 1]
#       
#       setnames(in_data_person_run_x, "idBenefitUnit", "id_BenefitUnit")
#       
#       setkey(in_data_person_run_x, id_BenefitUnit, run, time)
#       setkey(in_data_bu_run_x, id_BenefitUnit, run, time)
#       
#       as_tibble(in_data_person_run_x[in_data_bu_run_x]) |>
#         group_by(run) |>
#         write_dataset(out_dir)
#       
#     })
#     
#   })

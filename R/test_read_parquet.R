library(arrow)
library(tidyverse)

person_files <- file.path("//med2027.campus.gla.ac.uk", "projects", "projects", "HEED", "DataAnalysis", "simpaths_out_multirun", "arrow_files", "baseline_main", "person")

mh_by_run <- open_dataset(person_files) |> 
  map_batches(
    \(dat) {
      dat |> 
        group_by(run, time, dgn) |> 
        summarise(mean_mh = mean(dhm))
    }
  )

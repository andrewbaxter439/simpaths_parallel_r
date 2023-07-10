suppressPackageStartupMessages(library(tidyverse))

dir("output/logs") |>
    str_subset("txt") |> 
    map(~readLines(file.path("output/logs", .x))) |> 
    map(str_subset, "year.*seconds") |> 
    reduce(c) |> 
    str_extract("[\\d\\.]+(?= seconds)") |> 
    as.numeric() |>
    mean()

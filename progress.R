#!/usr/bin/env Rscript --vanilla

n_runs_env <- commandArgs(trailingOnly = TRUE)[1]

source("R/calc_full_time.R")
source("R/perc_complete.R")

#!/usr/bin/env Rscript


args_in <- commandArgs(trailingOnly = TRUE)

n_runs_env <- args_in[1]


time_message <- source("R/calc_full_time.R")
progress_message <- source("R/perc_complete.R")

if ("-textme" %in% args_in) {
  response <- httr::GET(URLencode(
    paste0(
      "https://api.telegram.org/bot",
      Sys.getenv("Notify_bot_key"),
      "/sendMessage?text=",
      time_message$value,
      progress_message$value,
      "&chat_id=",
      Sys.getenv("telegram_chatid")
    )
  ))
}
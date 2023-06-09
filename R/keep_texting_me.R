n_runs_env <- 1000


text_again <- TRUE

response <- httr::GET(URLencode(
    paste0(
      "https://api.telegram.org/bot",
      Sys.getenv("Notify_bot_key"),
      "/sendMessage?text=",
      "Starting a new cycle of ", n_runs_env, " runs",
      "&chat_id=",
      Sys.getenv("telegram_chatid")
      )))

while (text_again) {
  
  time_message <- source("R/calc_full_time.R")
  progress_message <- source("R/perc_complete.R")
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
  
  if (grepl("100.0%", progress_message$value)) text_again <- FALSE
  
  Sys.sleep(1800)
}

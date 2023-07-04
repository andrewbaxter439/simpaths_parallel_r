class_paths <- "simpaths.jar"

# test multi-run ----------------------------------------------------------

library(doParallel)
cores <- parallel::detectCores()

clusters <- 10 
n_runs <- 10 

cl <- parallel::makePSOCKcluster(clusters)

registerDoParallel(cl)

seed_starts <- purrr::map_int(seq(1, clusters), ~ .x * 100)
staggered_starts <- purrr::map_int(seq(1, clusters), ~ .x * 20 - 20)


t1 <- Sys.time()
foreach(seed = seed_starts, wait = staggered_starts, .packages = "rJava", .verbose = TRUE) %dopar% {
  options(java.parameters = "-Xmx4g")
  Sys.sleep(wait)
  .jinit()
  .jaddClassPath(class_paths)
  SimPathsMultiRun <- .jnew("simpaths.experiment.SimPathsMultiRun")
  .jcall(SimPathsMultiRun, method = "main", , c("-r", as.character(seed),
                                                "-g", "false",
                                                "-n", as.character(n_runs), 
                                                "-s", "2017",
                                                "-e", "2025",
                                                "-p", "140000",
                                                "-f"
                                                ))
}
difftime <- Sys.time() - t1
cat("This took", signif(difftime, 2), attr(difftime, "units"))

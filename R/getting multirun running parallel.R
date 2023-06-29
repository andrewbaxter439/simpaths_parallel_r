class_paths <- "labsim.jar"

# test multi-run ----------------------------------------------------------

library(doParallel)
cores <- parallel::detectCores()

clusters <- 20
n_runs <- 20

cl <- parallel::makePSOCKcluster(clusters)

registerDoParallel(cl)

seed_starts <- purrr::map_int(seq(1, clusters), ~ .x * 100)
staggered_starts <- purrr::map_int(seq(1, clusters), ~ .x * 20 - 20)


t1 <- Sys.time()
foreach(seed = seed_starts, wait = staggered_starts, n_runs = rep(n_runs, clusters), .packages = "rJava", .verbose = TRUE) %dopar% {
  Sys.sleep(wait)
  .jinit()
  .jaddClassPath("labsim.jar")
  SimPathsMultiRun <- .jnew("simpaths.experiment.SimPathsMultiRun")
  .jcall(SimPathsMultiRun, method = "main", , c("-r", as.character(seed),
                                                "-g", "false",
                                                "-n", as.character(n_runs), 
                                                "-s", "2017",
                                                "-e", "2025",
                                                "-p", "75000",
                                                "-f"
                                                ))
}
difftime <- Sys.time() - t1
cat("This took", signif(difftime, 2), attr(difftime, "units"))

# test one run ------------------------------------------------------------

library(rJava)
.jinit()

class_paths <- "labsim.jar"

.jaddClassPath(class_paths)

.jclassPath()
SimPathsMultiRun <- .jnew("simpaths.experiment.SimPathsMultiRun")


.jcall(SimPathsMultiRun, method = "main", , c("-r", "301", "-g", "false", "-n", "1", "-p", "75000", "-s", "2017", "-e", "2022", "-f"))
.jcall(SimPathsMultiRun, method = "main", , c("-r", "300", "-g", "false", "-n", "10", "-f"))
.jcall(SimPathsMultiRun, method = "main", , c("-r", "400", "-g", "false", "-n", "10", "-f"))
.jcall(SimPathsMultiRun, method = "main", , c("-r", "502", "-g", "false", "-n", "1", "-f"))
.jcall(SimPathsMultiRun, method = "main", , c("-r", "503", "-g", "false", "-n", "1", "-f"))
.jcall(SimPathsMultiRun, method = "main", , c("-r", "504", "-g", "false", "-n", "1", "-f"))

# class_paths <- vapply(
#   c("labsim/target/model-1.0.0.jar", 
#     "labsim/target/JAS-mine-core-4.1.0-jar-with-dependencies.jar",
#     dir("labsim/target/dependency", recursive = TRUE, full.names = TRUE)),
#   \(path) file.path(getwd(), path),
#   character(1),
#   USE.NAMES = FALSE
# )
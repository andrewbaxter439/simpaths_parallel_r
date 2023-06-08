class_paths <- "model.jar"

# test multi-run ----------------------------------------------------------
class_path <- "labsim.jar"

library(doParallel)
cores <- parallel::detectCores()

clusters <- 6
n_runs <- 10

cl <- parallel::makePSOCKcluster(6)

registerDoParallel(cl)

seed_starts <- purrr::map_int(seq(1, clusters), ~ .x * 100)
staggered_starts <- purrr::map_int(seq(1, clusters), ~ .x * 20 - 20)



# class_paths <- vapply(
#   c("labsim/target/model-1.0.0.jar", 
#     "labsim/target/JAS-mine-core-4.1.0-jar-with-dependencies.jar",
#     dir("labsim/target/dependency", recursive = TRUE, full.names = TRUE)),
#   \(path) file.path(getwd(), path),
#   character(1),
#   USE.NAMES = FALSE
# )

t1 <- Sys.time()
foreach(seed = seed_starts, wait = staggered_starts, n_runs = rep(n_runs, clusters), .packages = "rJava", .verbose = TRUE) %dopar% {
  Sys.sleep(wait)
  .jinit()
  .jaddClassPath(class_path)
  SimPathsMultiRun <- .jnew("simpaths.experiment.SimPathsMultiRun")
  .jcall(SimPathsMultiRun, method = "main", , c("-r", as.character(seed),
                                                "-g", "false",
                                                "-n", as.character(n_runs), 
                                                "-s", "2017",
                                                "-p", "10000",
                                                "-f"
                                                ))
}
difftime <- Sys.time() - t1
cat("This took", signif(difftime, 2), attr(difftime, "units"))

# test one run ------------------------------------------------------------

library(rJava)
.jinit()

# .jaddClassPath("labsim/target/model-1.0.0-jar-with-dependencies.jar")
.jaddClassPath(class_path)

.jclassPath()

SimPathsMultiRun <- .jnew("simpaths.experiment.SimPathsMultiRun")

.jcall(SimPathsMultiRun, method = "main", , c("-r", "301", "-g", "false", "-n", "1", "-p", "75000", "-s", "2017", "-e", "2022", "-f"))
.jcall(SimPathsMultiRun, method = "main", , c("-r", "300", "-g", "false", "-n", "10", "-f"))
.jcall(SimPathsMultiRun, method = "main", , c("-r", "400", "-g", "false", "-n", "10", "-f"))
.jcall(SimPathsMultiRun, method = "main", , c("-r", "502", "-g", "false", "-n", "1", "-f"))
.jcall(SimPathsMultiRun, method = "main", , c("-r", "503", "-g", "false", "-n", "1", "-f"))
.jcall(SimPathsMultiRun, method = "main", , c("-r", "504", "-g", "false", "-n", "1", "-f"))

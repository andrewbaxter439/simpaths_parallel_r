seeds <- 401:424



class_paths <- vapply(
  c("labsim/target/model-1.0.0.jar", 
    "labsim/target/JAS-mine-core-4.1.0-jar-with-dependencies.jar",
    dir("labsim/target/dependency", recursive = TRUE, full.names = TRUE)),
  \(path) file.path(getwd(), path),
  character(1),
  USE.NAMES = FALSE
)


# test one run ------------------------------------------------------------

library(rJava)
.jinit()

# .jaddClassPath("labsim/target/model-1.0.0-jar-with-dependencies.jar")
.jaddClassPath(class_paths)

.jclassPath()

SimPathsMultiRun <- .jnew("simpaths.experiment.SimPathsMultiRun")

.jcall(SimPathsMultiRun, method = "main", , c("-r", "301", "-g", "false", "-n", "1", "-f"))
.jcall(SimPathsMultiRun, method = "main", , c("-r", "401", "-g", "false", "-n", "1", "-f"))
.jcall(SimPathsMultiRun, method = "main", , c("-r", "502", "-g", "false", "-n", "1", "-f"))
.jcall(SimPathsMultiRun, method = "main", , c("-r", "503", "-g", "false", "-n", "1", "-f"))
.jcall(SimPathsMultiRun, method = "main", , c("-r", "504", "-g", "false", "-n", "1", "-f"))
# test multi-run ----------------------------------------------------------


library(doParallel)
cores <- parallel::detectCores()
cl <- parallel::makePSOCKcluster(6)

registerDoParallel(cl)

staggered_starts <- seq(0, 100, by = 20)

seed_starts <- seq(100, 600, by = 100)

t1 <- Sys.time()
foreach(seed = seed_starts, wait = staggered_starts, .packages = "rJava", .verbose = TRUE) %dopar% {
  Sys.sleep(wait)
  .jinit()
  .jaddClassPath(class_paths)
  SimPathsMultiRun <- .jnew("simpaths.experiment.SimPathsMultiRun")
  .jcall(SimPathsMultiRun, method = "main", , c("-r", seed, "-g", "false", "-n", "10", "-f"))
}
difftime <- Sys.time() - t1
cat("This took", signif(difftime, 2), attr(difftime, "units"))
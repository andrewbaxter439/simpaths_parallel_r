library(rJava)
.jinit()

class_paths <- "simpaths.jar"

# .jaddClassPath("labsim/target/model-1.0.0-jar-with-dependencies.jar")
.jaddClassPath(class_paths)

.jclassPath()

SimPathsMultiRun <- .jnew("simpaths.experiment.SimPathsMultiRun")

.jcall(SimPathsMultiRun, method = "main", , c("-r", "301", "-g", "false", "-n", "1", "-p", "75000", "-s", "2017", "-e", "2022", "-f"))

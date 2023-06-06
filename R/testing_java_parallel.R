library(rJava)
.jinit()
.jaddClassPath(file.path(getwd(), "java_test/out/production/java_test"))

calc <- .jnew("somepackage.Calculator")
.jcall(calc, "I", "addUp", 1:10)

obj <- .jnew("somepackage.Hello")
.jmethods(obj)

obj$SayHi(c("Pandy", ""))

calc$addUp(1:10)

# in parallel -------------------------------------------------------------


library(doParallel)
cores <- parallel::detectCores()
cl <- parallel::makePSOCKcluster(6)

registerDoParallel(cl)

addups <- lapply(1:12, sample, x = 1:1000000, size = 1000000)

t1 <- Sys.time()
sums <- foreach(nums = addups, .combine = "c", .packages = "rJava") %dopar% {
  .jinit()
  .jaddClassPath(file.path(getwd(), "java_test/out/production/java_test"))
  calc <- .jnew("somepackage.Calculator")
  .jcall(calc, "I", "addUp", nums)
}
cat("This took", Sys.time() - t1, "seconds")

registerDoSEQ()

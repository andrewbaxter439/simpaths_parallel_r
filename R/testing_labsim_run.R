# setup -------------------------------------------------------------------
library(tidyverse)
library(rJava)
.jinit()

dir("labsim/target/dependency", recursive = TRUE, full.names = TRUE) |>
  str_subset(".*\\.jar$") |>
  map(.jaddClassPath)
# 
# .jaddClassPath(file.path(getwd(), "target/classes"))
# .jaddClassPath("C:/Users/ab542x/.m2/repository/com/github/jasmineRepo/JAS-mine-core/4.1.0/JAS-mine-core-4.1.0.jar")
# .jaddClassPath("C:/Users/ab542x/.m2/repository")
# .jaddClassPath("C:/Users/ab542x/.m2/repository/log4j/log4j/1.2.17/log4j-1.2.17.jar")
# # .jaddClassPath("C:/Users/ab542x/.m2/repository/org/apache/commons/commons-collections4/4.4/commons-collections4-4.4.jar")

.jaddClassPath(file.path(getwd(), "labsim/target/model-1.0.0.jar"))
.jaddClassPath(file.path(getwd(), "labsim/target/dependency/*"))

.jclassPath()
# initialising classes ----------------------------------------------------

# LABSimStart experimentBuilder = new LABSimStart();

labSimModel <- .jnew("labsim.model.LABSimModel", J("labsim.model.enums.Country")$UK)

# SimulationEngine engine = SimulationEngine.getInstance();
SimulationEngine <- .jnew("microsim.engine.SimulationEngine")
engine <- SimulationEngine$getInstance()

engine$startSimulation()
# engine.setExperimentBuilder(experimentBuilder);


collector <- .jnew("labsim.experiment.LABSimCollector",  .jcast(labSimModel, "microsim.engine.SimulationManager"))

# engine.setExperimentBuilder(experimentBuilder);
#   engine.setup();	

#   experimentBuilder.start();



#   countryString = "United Kingdom";



# private static int maxNumberOfRuns = 20;
# private static String countryString;
# private static int startYear;
# private Long counter = 0L;
# private Long randomSeed = 615L;

# trying LabSimStart ------------------------------------------------------


LABSimStart <- .jnew("labsim.experiment.LABSimStart")

.jcall(LABSimStart, method = "main", , c("", ""))

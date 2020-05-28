
base::cat("Display the current library path \n \n")
thePaths <- base::normalizePath(path = .libPaths(), 
                                winslash = "/")
base::print(thePaths)
base::cat("\n")

snapshotDateForPackages <- "2020-03-01"

pathFile <- base::file.path("CheckpointUtils.R")
base::source(file = pathFile,
             local = TRUE)

packagesThatAreNeededFirst <- c("checkpoint")
InstallPackages_Overlay(
  packagesToCheck_IP_O = packagesThatAreNeededFirst,
  snapshotDate_IP_O = snapshotDateForPackages)

SetupSnapshot(snapshotDate_S = snapshotDateForPackages)

packagesNotScannedByCheckpoint <- c("plotly",
    "shinythemes","highcharter","DT","fastmatch","feather","kableExtra",
    "rio","highr","shinyjs","shiny.semantic","rmarkdown","svglite","gplots",
    "shinydashboard","RQuantLib","narray","processx","rlang","rhandsontable")

InstallPackages_Overlay(
  packagesToCheck_IP_O = packagesNotScannedByCheckpoint,
  snapshotDate_IP_O = snapshotDateForPackages)

InstallPackages_ExplicitVersion()

InspectResultsCheckpoint()

## just to ensure that tidyverse (and dependencies) is installed
checkTidyverseDependencies <- TRUE
if (checkTidyverseDependencies) {
  tidyverse::tidyverse_deps()
  tidyverse::tidyverse_packages()
}

base::cat("Display the current library path \n \n")
thePaths <- base::normalizePath(path = .libPaths(), 
                                winslash = "/")
base::print(thePaths)



GetVersionR <- function()
{
  nameFunctionForMessage <- "GetVersionR() "    
##  reportr::setOutputLevel(reportr::OL$Error)  
  
  versionR <- base::R.Version()
  
  versionR_Checkpoint <- base::paste0(versionR$major,".",versionR$minor)
  versionR <- base::paste0("R.",versionR$major,".",versionR$minor)
  versionR <- base::gsub(
    pattern = ".", 
    replacement = "_", 
    x = versionR, 
    fixed = TRUE)
  
  infoVersionR <- list()
  infoVersionR[["VersionR_Checkpoint"]] <- versionR_Checkpoint
  infoVersionR[["VersionR"]] <- versionR
  
  return(infoVersionR)
}


GetPathFolderCheckpoint <- function(snapshotDate_GPFC)
{
  versionR <- GetVersionR()
  pathMyDocumentsFolder <- base::path.expand('~')
  pathFolder <- base::file.path(pathMyDocumentsFolder,".checkpoint", snapshotDate_GPFC,
                                "lib","x86_64-w64-mingw32", versionR)
  return(pathFolder)
}



SetupSnapshot <- function(snapshotDate_S)
{
  nameFunctionForMessage <- "SetupSnapshot() "    
  ##  reportr::setOutputLevel(reportr::OL$Error)  
  
  infoVersionR <- GetVersionR()
  versionR <- infoVersionR[["VersionR"]]
  versionR_Checkpoint <- infoVersionR[["VersionR_Checkpoint"]]
  
##  theCheckpointFolder <- base::file.path(base::getwd(),"Checkpoint_Repo")
## snapshot has some issues if a different folder is used instead of default one
  theCheckpointFolder <- "~/"
  if (!(base::dir.exists(theCheckpointFolder))) {
    base::dir.create(theCheckpointFolder)
  }
  
  if (versionR == "R_3_5_3") {
    theMessage <- base::paste0("versionR = ", versionR, " is not an acceptable selection")
    base::stop(theMessage)
  } else if (versionR == "R_3_6_0") {
    theMessage <- base::paste0("versionR = ", versionR, " is not an acceptable selection")
    base::stop(theMessage)
  } else if (versionR == "R_3_6_1") {
    theMessage <- base::paste0("versionR = ", versionR, " is not an acceptable selection")
    base::stop(theMessage)
  } else if (versionR == "R_3_6_2") {
    checkpointSnapshotDate <- snapshotDate_S 
  } else {
    theMessage <- base::paste0("versionR = ", versionR, " is not an acceptable selection")
    base::stop(theMessage)
  }  
  
  base::options(checkpoint.mranUrl = NULL)
  
  reposInUse <- base::getOption("repos")
  theMessage <- base::paste0("ReposInUse = ", reposInUse, "\n\n")
  base::cat(theMessage)
  
  theMessage <- base::paste0("Snapshot date = ", checkpointSnapshotDate, "\n\n")
  base::cat(theMessage)
  
  checkpoint::checkpoint(
    snapshotDate = checkpointSnapshotDate,
    R.version = versionR_Checkpoint,
    checkpointLocation = theCheckpointFolder,
    forceInstall = FALSE, 
    verbose = TRUE,
    use.knitr = TRUE,
    scan.rnw.with.knitr = TRUE,
    auto.install.knitr = TRUE)
  
}


InspectResultsCheckpoint <- function()
{
  
  base::cat("Check that library path is set to checkpoint folder\n \n")
  thePaths <- base::normalizePath(path = .libPaths(), 
                                  winslash = "/")
  base::print(thePaths)
  
  base::cat("These packages are installed in checkpoint library\n \n")
  utils::installed.packages(.libPaths()[1])[, "Package"]
  
}


RemoveCheckpointArchive <- function(snapshotDate_RCA)
{
  versionR <- base::R.Version()
  
  versionR_Checkpoint <- base::paste0(versionR$major,".",versionR$minor)
  versionR <- base::paste0("R.",versionR$major,".",versionR$minor)
  versionR <- base::gsub(
    pattern = ".", 
    replacement = "_", 
    x = versionR, 
    fixed = TRUE)
  
  if (versionR == "R_3_5_3") {
    theMessage <- base::paste0("versionR = ", versionR, " is not an acceptable selection")
    base::stop(theMessage)
  } else if (versionR == "R_3_6_0") {
    theMessage <- base::paste0("versionR = ", versionR, " is not an acceptable selection")
    base::stop(theMessage)
  } else if (versionR == "R_3_6_1") {
    theMessage <- base::paste0("versionR = ", versionR, " is not an acceptable selection")
    base::stop(theMessage)
  } else if (versionR == "R_3_6_2") {
    checkpointSnapshotDate <- snapshotDate_RCA 
  } else {
    theMessage <- base::paste0("versionR = ", versionR, " is not an acceptable selection")
    base::stop(theMessage)
  }  
  
##  theCheckpointFolder <- base::file.path(base::getwd(),"Checkpoint_Repo")
## snapshot have some issues if a different folder is used instead of default one
  theCheckpointFolder <- "~/" 
  
  checkpoint::checkpointRemove(
    snapshotDate = checkpointSnapshotDate,
    checkpointLocation = theCheckpointFolder)
}


InstallPackages_Overlay <- function(
    packagesToCheck_IP_O,
    snapshotDate_IP_O)
{
  nameFunctionForMessage <- "InstallPackages_Overlay() "
  
  repoToInstallFrom <- base::paste0("https://mran.microsoft.com/snapshot/", 
                                    snapshotDate_IP_O, "/")
  
  whereToCheck <- GetPathFolderCheckpoint(snapshotDate_GPFC = snapshotDate_IP_O)
  installPackagesIsNeeded <- ((packagesToCheck_IP_O %in% utils::installed.packages(lib.loc = whereToCheck)[, 1]) == FALSE)
  needToInstallVect <- ifelse(test = installPackagesIsNeeded, 
                              yes = TRUE, 
                              no = FALSE)
  needToInstall <- base::any(needToInstallVect)
  if (needToInstall) {
    utils::install.packages(pkgs = packagesToCheck_IP_O[needToInstallVect],
                            repos = repoToInstallFrom)
    
  }
}


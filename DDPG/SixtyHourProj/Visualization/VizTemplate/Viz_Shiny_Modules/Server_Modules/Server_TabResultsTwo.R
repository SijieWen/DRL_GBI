


Mod_Viz_Server_TabResultsTwo <- modules::module(
{

## packages that need to be explicitly imported within this module 
#    modules::import(from = "dplyr")  ## needed for %>%


## define local piping operator, to avoid loading dplyr package
    `%>%` <- dplyr::`%>%`


## local files or functions that have to be imported explicitly
#   nameForLocalUsage <- modules::use(module = "SomeName")  


## functions exported from this module
    modules::export("RenderContent")
    modules::export("SampleDT")


RenderContent <- function(
## the first three arguments of the function have to be input, output and session
    input, output, session,  
## the regular function arguments
    data_MVSTR2_RC,
    funcs_MVSTR2_RC,
    reactiveInputs_MVSTR2_RC, 
    reactiveVars_MVSTR2_RC,
    reactiveTriggers_MVSTR2_RC,
    output_MVSTR2_RC)
{
  nameFunctionForMessage <- "Mod_Viz_Server_TabResultsTwo$RenderContent() "    
  reportr::setOutputLevel(reportr::OL$Error)
  
  objReactive_UserInputs <- reactiveInputs_MVSTR2_RC
  
  theOutputIDs <- output_MVSTR2_RC
  
  shiny::observeEvent(
    
    eventExpr = reactiveInputs_MVSTR2_RC[["InvestorName"]],
    
    handlerExpr = {
      
      theOutputIDs$outputID_TabResultsTwo_FirstSubTab_TableDT <- DT::renderDataTable({
        
        theData <- data_MVSTR2_RC[["DataCars"]]
        base::colnames(theData)[3] <- "Original"
        
        shiny::callModule(
          module = SampleDT,
          id = "ID_Mod_Viz_Svr_TabReport2_SampleDT",
          data_MVSTR2_SDT = theData,
          funcs_MVSTR2_SDT = funcs_MVSTR2_RC)
    })
      
  })   
  
  
  shiny::observeEvent(
    
    eventExpr = reactiveInputs_MVSTR2_RC[["InvestorName"]],
    
    handlerExpr = {
      
      theOutputIDs$outputID_TabResultsTwo_ThirdSubTab_TableDT <- DT::renderDataTable({
        
        theData <- round(data_MVSTR2_RC[["DataGoalSeries"]],3)
        base::colnames(theData)[3] <- "Original"
        
        shiny::callModule(
          module = SampleDT,
          id = "ID_Mod_Viz_Svr_TabReport2_SampleDT",
          data_MVSTR2_SDT = theData,
          funcs_MVSTR2_SDT = funcs_MVSTR2_RC)
    })
      
  })  
  
  return(theOutputIDs)
}


SampleDT <- function(
## the first three arguments of the function have to be input, output and session
    input, output, session,  
## the regular function arguments
    data_MVSTR2_SDT,
    funcs_MVSTR2_SDT)
{
  nameFunctionForMessage <- "Mod_Viz_Server_TabReportTwo$SampleDT() "    
  reportr::setOutputLevel(reportr::OL$Error)
  
  outputTable <- DT::datatable(data = data_MVSTR2_SDT)
  numColsTable <- base::ncol(data_MVSTR2_SDT)
  
  # outputTable <- DT::formatRound(
  #   table = outputTable,
  #   columns = c(2:numColsTable),
  #   digits = 2)
  
  theOutput <- DT::formatStyle(
    table = outputTable,
    columns = c(2:numColsTable),
    'text-align' = 'center')
  
  return(theOutput)
} 

})

runPathwayApp <- function() {
  if(!require(clusterProfiler))BiocManager::install("clusterProfiler")
  if(!require(pathview))BiocManager::install("pathview")
  if(!require(ReactomePA))BiocManager::install("ReactomePA")
  if(!require(dplyr))install.packages("dplyr")
  if(!require(shiny))install.packages("shiny")
  if(!require(shinydashboard))install.packages("shinydashboard")
  if(!require(ggplot2))install.packages("ggplot2")
  if(!require(shinycssloaders))install.packages("shinycssloaders")
  if(!require(knitr))install.packages("knitr")
  if(!require(kableExtra))install.packages("kableExtra")
  if(!require(formattable))install.packages("formattable")
  if(!require(shinyhelper))install.packages("shinyhelper")
  if(!require(pathviewPatched))devtools::install_github("vdruchkiv/TFM/5_Packages/pathviewPatched")
  appDir <- system.file("shiny-examples", "PathwayApp", package = "PathwayApp")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `PathwayApp`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}

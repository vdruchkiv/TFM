runPathwayApp <- function() {
  appDir <- system.file("shiny-examples", "PathwayApp", package = "PathwayApp")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `PathwayApp`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}

runExample <- function() {
  appDir <- system.file("shiny-examples", "PathwayApp", package = "PathwayAppPackage")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `PathwayAppPackage`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}

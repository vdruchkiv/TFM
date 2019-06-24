## ui.R ##
library(shiny)
library(shinydashboard)
library(ReactomePA)
library(ggplot2)
library(dplyr)
library(clusterProfiler)
library(shinycssloaders)
library(knitr)
library(kableExtra)
library(formattable)
library(pathview)
library(png)
library(shinyhelper)

ui <- dashboardPage(
  dashboardHeader(title = "Pathway analysis"%>%helper(icon = "question",
                                                      colour = "red",
                                                      type = "markdown",
                                                      content = "Manual")),
  dashboardSidebar(
    sidebarMenu(
    menuItem("Data input", tabName = "dataInput", icon = icon("upload")),
    menuItem("GO Analysis",
    menuItem("ORA", tabName = "EnrichSpecs_GO", icon = icon("sliders-h")),
    menuItem("GSEA", tabName = "GSEA_GO", icon = icon("sliders-h")),
    menuItem("Bar Plot", tabName = "BarPlot_GO", icon = icon("chart-bar")),
    menuItem("Dot Plot", tabName = "DotPlot_GO", icon = icon("chart-bar")),
    menuItem("Enrichment Plot", tabName = "Emap_GO", icon = icon("bezier-curve")),
    menuItem("Category-gene-network", tabName = "cnetplot_GO", icon = icon("bezier-curve")),
    menuItem("GSEA plot", tabName = "gsea_GO", icon = icon("share-square")),
    menuItem("GOplot", tabName = "goplot_GO", icon = icon("bezier-curve"))
    ),
    menuItem("KEGG Analysis",
             menuItem("ORA", tabName = "EnrichSpecs_KEGG", icon = icon("sliders-h")),
             menuItem("GSEA", tabName = "GSEA_KEGG", icon = icon("sliders-h")),
             menuItem("Bar Plot", tabName = "BarPlot_KEGG", icon = icon("chart-bar")),
             menuItem("Dot Plot", tabName = "DotPlot_KEGG", icon = icon("chart-bar")),
             menuItem("Enrichment Plot", tabName = "Emap_KEGG", icon = icon("bezier-curve")),
             menuItem("Category-gene-network", tabName = "cnetplot_KEGG", icon = icon("bezier-curve")),
             menuItem("GSEA plot", tabName = "gsea_KEGG", icon = icon("share-square")),
             menuItem("KEGG Pathway", tabName = "pathway_KEGG", icon = icon("bezier-curve"))
    ),
    menuItem("Reactome Analysis",
             menuItem("ORA", tabName = "EnrichSpecs_RA", icon = icon("sliders-h")),
             menuItem("GSEA", tabName = "GSEA_RA", icon = icon("sliders-h")),
             menuItem("Bar Plot", tabName = "BarPlot_RA", icon = icon("chart-bar")),
             menuItem("Dot Plot", tabName = "DotPlot_RA", icon = icon("chart-bar")),
             menuItem("Enrichment Plot", tabName = "Emap_RA", icon = icon("bezier-curve")),
             menuItem("Category-gene-network", tabName = "cnetplot_RA", icon = icon("bezier-curve")),
             menuItem("GSEA plot", tabName = "gsea_RA", icon = icon("share-square")),
             menuItem("Reactome Pathway", tabName = "path_RA", icon = icon("bezier-curve"))
    )

  )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "dataInput",
        fluidRow(
          h3(strong("Select Specie"))%>%helper(icon = "question",
                                               colour = "green",
                                               type = "markdown",
                                               content = "SelectingSpecie",
                                               style = "position:relative;left: 150px;top: -31px"),
          h3(strong("GO"),style = "color:#335EFF;"),
          selectInput("specie_go", "Select Specie:",
                      c("Homo Sapiens" = "org.Hs.eg.db",
                        "Rat" = "org.Rn.eg.db",
                        "Mouse"="org.Mm.eg.db",
                        "Celegans"="org.Ce.eg.db",
                        "Yeast"="org.Sc.sgd.db",
                        "Zebrafish"="org.Dr.eg.db",
                        "Fly"="org.Dm.eg.db",
                        "Arabidopsis"="org.At.tair.db",
                        "Bovine"="org.Bt.eg.db",
                        "Chicken"="org.Gg.eg.db",
                        "Canine"="org.Cf.eg.db",
                        "Pig"="org.Ss.eg.db2",
                        "Rhesus"="org.Mmu.eg.db",
                        "E coli strain K12"="org.EcK12.eg.db",
                        "Xenopus"="org.Xl.eg.db",
                        "Anopheles"="org.Ag.eg.db",
                        "Chimp"="org.Pt.eg.db",
                        "Malaria"="org.Pf.plasmo.db",
                        "E coli strain Sakai"="org.EcSakai.eg.db")),
          tags$hr(style="border-color: black;"),
          h3(strong("Reactome"),style = "color:#335EFF;"),
          selectInput("specie", "Select Specie:",
                      c("Homo Sapiens" = "human",
                        "Rat" = "rat",
                        "Mouse"="mouse",
                        "Celegans"="celegans",
                        "Yeast"="yeast",
                        "Zebrafish"="zebrafish",
                        "Fly"="fly")),
          tags$hr(style="border-color: black;"),
          h3(strong("KEGG"),style = "color:#335EFF;"),
          textInput("searchKEGGspecie", "Enter Search Term for Specie", "homo"),
          htmlOutput("SelSpecieKEGG"),
          tags$hr(style="border-color: black;"),
          h3(strong("Upload Data"))%>%helper(icon = "question",
                    colour = "green",
                    type = "markdown",
                    content = "UploadingData",
                    style = "position:relative;left: 150px;top: -31px"),
          fileInput("file1", h3(strong("File with all genes"),style = "color:#335EFF;"),
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
          fileInput("file2", h3(strong("File with selected genes"),style = "color:#335EFF;"),
                    multiple = FALSE,
                    accept = c("text/csv",
                               "text/comma-separated-values,text/plain",
                               ".csv")),
          tags$hr(style="border-color: black;"),
          tableOutput("InputTable"),
          textOutput("TxtEnterdGenes"),
          htmlOutput("data_preview")%>%withSpinner(color="#0dc5c1"),
          textOutput("TxtSelectedGenes"),
          htmlOutput("data_preview2")%>%withSpinner(color="#0dc5c1")
        )
        ), #Item 1 End
        #Enrichment Specs GO Tab
        tabItem(tabName = "EnrichSpecs_GO",
                fluidRow(
                  radioButtons("ont_go", h3("Select ontology:"),
                              c("Cellular Component" = "CC",
                                "Molecular Function" = "MF",
                                "Biological Process" = "BP"),inline = TRUE),
                  selectInput("adj_go",h3("Select adjustment method"),
                              c("holm"="holm",
                                "hochberg"="hochberg",
                                "hommel"="hommel",
                                "bonferroni"="bonferroni",
                                "BH"="BH",
                                "BY"="BY",
                                "fdr"="fdr",
                                "none"="none"))%>%helper(icon = "question",
                                                         colour = "green",
                                                         type = "markdown",
                                                         content = "Help_padjust",
                                                         style = "position:relative;left: 300px;top: -45px"),
                  radioButtons("pval_go", h3("Select P-Value threshold:"),
                                           c("0.1" = 0.1,
                                             "0.05" = 0.05,
                                             "0.01" = 0.01,
                                             "0.001" = 0.001),inline = TRUE),
                 actionButton("calcGo","Calculate Result"),
                 tags$hr(style="border-color: black;"),
                 uiOutput("download_er_go"),
                 htmlOutput("EnrichResultTable_GO")%>%withSpinner(color="#0dc5c1")
                )#FluidRow
        ),#Item2 End
      #Enrichment Specs GO Tab
      tabItem(tabName = "GSEA_GO",
              fluidRow(
                radioButtons("ont_go_gsea", h3("Select ontology:"),
                             c("Cellular Component" = "CC",
                               "Molecular Function" = "MF",
                               "Biological Process" = "BP"),inline = TRUE),
                radioButtons("pval_go_gsea", h3("Select P-Value threshold:"),
                             c("0.1" = 0.1,
                               "0.05" = 0.05,
                               "0.01" = 0.01,
                               "0.001" = 0.001),inline = TRUE),
                selectInput("adj_gsea_go",h3("Select adjustment method"),
                            c("holm"="holm",
                              "hochberg"="hochberg",
                              "hommel"="hommel",
                              "bonferroni"="bonferroni",
                              "BH"="BH",
                              "BY"="BY",
                              "fdr"="fdr",
                              "none"="none"))%>%helper(icon = "question",
                                                       colour = "green",
                                                       type = "markdown",
                                                       content = "Help_padjust",
                                                       style = "position:relative;left: 300px;top: -45px"),
                actionButton("calcGoGsea","Calculate Result"),
                tags$hr(style="border-color: black;"),
                uiOutput("download_er_go_gsea"),
                htmlOutput("EnrichResultTable_GO_gsea")%>%withSpinner(color="#0dc5c1")
              )#FluidRow
        ),#Item3 End
      #Bar Plot GO Tab
      tabItem(tabName = "BarPlot_GO",
              fluidRow(
                sliderInput("cat_barplotgo", "Number of categories",
                            min = 2, max = 30,  value = 15),
                imageOutput("BarPlot_GO2")%>%withSpinner(color="#0dc5c1"),
                box(title="Image download options",
                    status = "primary",width=3,
                numericInput("wid_bp_go","Width (pixel)",value=1600),
                numericInput("hei_bp_go","Height (pixel)",value = 1200),
                numericInput("res_bp_go","Resolution",value=300),
                numericInput("text_bp_go","Text size",value=7),
                downloadButton("downloadBarPlotGo","Download Plot as .png"))
              )#FluidRow
      ),#Item4 End
      #Dot Plot GO Tab
      tabItem(tabName = "DotPlot_GO",
              fluidRow(
                sliderInput("cat_dotplotgo", "Number of categories",
                            min = 2, max = 30,  value = 15),
                imageOutput("DotPlot_GO2")%>%withSpinner(color="#0dc5c1"),
                box(title="Image download options",
                    status = "primary",width=3,
                    numericInput("wid_dp_go","Width (pixel)",value=1600),
                    numericInput("hei_dp_go","Height (pixel)",value = 1200),
                    numericInput("res_dp_go","Resolution",value=300),
                    numericInput("text_dp_go","Text size",value=7),
                    downloadButton("downloadDotPlotGo","Download Plot as .png"))
              )#FluidRow
      ),#Item5 End
      #Emapplot
    tabItem(tabName = "Emap_GO",
            fluidRow(
              sliderInput("cat_emapplotgo", "Number of categories",
                          min = 0, max = 30,  value = 15),
              imageOutput("EmapPlot_GO2")%>%withSpinner(color="#0dc5c1"),
              box(title="Image download options",
                  status = "primary",width=3,
                  numericInput("wid_ep_go","Width (pixel)",value=1600),
                  numericInput("hei_ep_go","Height (pixel)",value = 1200),
                  numericInput("res_ep_go","Resolution",value=300),
                  downloadButton("downloadEmapPlotGo","Download Plot as .png"))
            )#FluidRow
    ),#Item6 End
    tabItem(tabName = "cnetplot_GO",
            fluidRow(
              sliderInput("cat_cnetplotgo", "Number of categories",
                          min = 0, max = 30,  value = 15),
              imageOutput("CnetPlot_GO2")%>%withSpinner(color="#0dc5c1"),
              box(title="Image download options",
                  status = "primary",width=3,
                  numericInput("wid_cp_go","Width (pixel)",value=1600),
                  numericInput("hei_cp_go","Height (pixel)",value = 1200),
                  numericInput("res_cp_go","Resolution",value=300),
                  downloadButton("downloadCnetPlotGo","Download Plot as .png"))
            )#FluidRow
    ),#Item7 End
    tabItem(tabName = "goplot_GO",
            fluidRow(
              sliderInput("cat_goplotgo", "Number of categories",
                          min = 0, max = 30,  value = 15),
              imageOutput("GoPlot_GO2")%>%withSpinner(color="#0dc5c1"),
              box(title="Image download options",
                  status = "primary",width=3,
                  numericInput("wid_gp_go","Width (pixel)",value=1600),
                  numericInput("hei_gp_go","Height (pixel)",value = 1200),
                  numericInput("res_gp_go","Resolution",value=300),
                  downloadButton("downloadGoPlotGo","Download Plot as .png"))
            )#FluidRow
    ),#Item8 End
    tabItem(tabName = "gsea_GO",
            fluidRow(
              htmlOutput("setsGseaGo"),
              imageOutput("GseaPlot_GO2")%>%withSpinner(color="#0dc5c1"),
              box(title="Image download options",
                  status = "primary",width=3,
                  numericInput("wid_gsp_go","Width (pixel)",value=1600),
                  numericInput("hei_gsp_go","Height (pixel)",value = 1200),
                  numericInput("res_gsp_go","Resolution",value=300),
                  downloadButton("downloadGseaPlotGo","Download Plot as .png"))
            )#FluidRow
    ),#Item9 End
############################KEGG#########################################
    tabItem(tabName = "EnrichSpecs_KEGG",
            fluidRow(
              radioButtons("pval_kegg", h3("Select P-Value threshold:"),
                           c("0.1" = 0.1,
                             "0.05" = 0.05,
                             "0.01" = 0.01,
                             "0.001" = 0.001),inline = TRUE),
              selectInput("adj_kegg",h3("Select adjustment method"),
                          c("holm"="holm",
                            "hochberg"="hochberg",
                            "hommel"="hommel",
                            "bonferroni"="bonferroni",
                            "BH"="BH",
                            "BY"="BY",
                            "fdr"="fdr",
                            "none"="none"))%>%helper(icon = "question",
                                                     colour = "green",
                                                     type = "markdown",
                                                     content = "Help_padjust",
                                                     style = "position:relative;left: 300px;top: -45px"),
              actionButton("calcKEGG","Calculate Result"),
              tags$hr(style="border-color: black;"),
              uiOutput("download_er_kegg"),
              htmlOutput("EnrichResultTable_KEGG")%>%withSpinner(color="#0dc5c1")
            )#FluidRow
    ),#Item10 End
    tabItem(tabName = "GSEA_KEGG",
        fluidRow(
          radioButtons("pval_kegg_gsea", h3("Select P-Value threshold:"),
                       c("0.1" = 0.1,
                         "0.05" = 0.05,
                         "0.01" = 0.01,
                         "0.001" = 0.001),inline = TRUE),
          selectInput("adj_gsea_kegg",h3("Select adjustment method"),
                      c("holm"="holm",
                        "hochberg"="hochberg",
                        "hommel"="hommel",
                        "bonferroni"="bonferroni",
                        "BH"="BH",
                        "BY"="BY",
                        "fdr"="fdr",
                        "none"="none"))%>%helper(icon = "question",
                                                 colour = "green",
                                                 type = "markdown",
                                                 content = "Help_padjust",
                                                 style = "position:relative;left: 300px;top: -45px"),
          actionButton("calcKeggGsea","Calculate Result"),
          tags$hr(style="border-color: black;"),
          uiOutput("download_er_kegg_gsea"),
          htmlOutput("EnrichResultTable_KEGG_gsea")%>%withSpinner(color="#0dc5c1")
        )#FluidRow
    ), #Item11
      #Bar Plot KEGG Tab
    tabItem(tabName = "BarPlot_KEGG",
        fluidRow(
          sliderInput("cat_barplotkegg", "Number of categories",
                      min = 2, max = 30,  value = 15),
          imageOutput("BarPlot_KEGG2")%>%withSpinner(color="#0dc5c1"),
          box(title="Image download options",
              status = "primary",width=3,
              numericInput("wid_bp_kegg","Width (pixel)",value=1600),
              numericInput("hei_bp_kegg","Height (pixel)",value = 1200),
              numericInput("res_bp_kegg","Resolution",value=300),
              numericInput("text_bp_kegg","Text size",value=7),
              downloadButton("downloadBarPlotKegg","Download Plot as .png"))
        )#FluidRow
    ),#Item12 End
    #Dot Plot KEGG Tab
    tabItem(tabName = "DotPlot_KEGG",
        fluidRow(
          sliderInput("cat_dotplotkegg", "Number of categories",
                      min = 2, max = 30,  value = 15),
          imageOutput("DotPlot_KEGG2")%>%withSpinner(color="#0dc5c1"),
          box(title="Image download options",
              status = "primary",width=3,
              numericInput("wid_dp_kegg","Width (pixel)",value=1600),
              numericInput("hei_dp_kegg","Height (pixel)",value = 1200),
              numericInput("res_dp_kegg","Resolution",value=300),
              numericInput("text_dp_kegg","Text size",value=7),
          downloadButton("downloadDotPlotKegg","Download Plot as .png"))
        )#FluidRow
    ), #Item13 End
    #Emapplot
    tabItem(tabName = "Emap_KEGG",
                fluidRow(
                  sliderInput("cat_emapplotkegg", "Number of categories",
                              min = 0, max = 30,  value = 15),
                  imageOutput("EmapPlot_KEGG2")%>%withSpinner(color="#0dc5c1"),
                  box(title="Image download options",
                      status = "primary",width=3,
                      numericInput("wid_ep_kegg","Width (pixel)",value=1600),
                      numericInput("hei_ep_kegg","Height (pixel)",value = 1200),
                      numericInput("res_ep_kegg","Resolution",value=300),
                  downloadButton("downloadEmapPlotKegg","Download Plot as .png"))
                )#FluidRow
        ), #Item14 End
    tabItem(tabName = "cnetplot_KEGG",
        fluidRow(
          sliderInput("cat_cnetplotkegg", "Number of categories",
                      min = 0, max = 30,  value = 15),
          imageOutput("CnetPlot_KEGG2")%>%withSpinner(color="#0dc5c1"),
          box(title="Image download options",
              status = "primary",width=3,
              numericInput("wid_cp_kegg","Width (pixel)",value=1600),
              numericInput("hei_cp_kegg","Height (pixel)",value = 1200),
              numericInput("res_cp_kegg","Resolution",value=300),
          downloadButton("downloadCnetPlotKegg","Download Plot as .png"))
        )#FluidRow
    ),#Item14 End
    tabItem(tabName = "gsea_KEGG",
        fluidRow(
          htmlOutput("setsGseaKegg"),
          imageOutput("GseaPlot_KEGG2")%>%withSpinner(color="#0dc5c1"),
          box(title="Image download options",
              status = "primary",width=3,
              numericInput("wid_gsp_kegg","Width (pixel)",value=1600),
              numericInput("hei_gsp_kegg","Height (pixel)",value = 1200),
              numericInput("res_gsp_kegg","Resolution",value=300),
          downloadButton("downloadGseaPlotKegg","Download Plot as .png"))
        )#FluidRow
    ), #Item15 End
    tabItem(tabName = "pathway_KEGG",
        fluidRow(
          htmlOutput("PathKeggUi"),
          downloadButton("downloadPathKegg","Download Plot as .png"),
          imageOutput("pathway_KEGG2")%>%withSpinner(color="#0dc5c1")
        )#FluidRow
), #Item16 End
#Enrichment Specs Reactome Tab
    tabItem(tabName = "EnrichSpecs_RA",
        fluidRow(
          selectInput("adj_RA",h3("Select adjustment method"),
                      c("holm"="holm",
                        "hochberg"="hochberg",
                        "hommel"="hommel",
                        "bonferroni"="bonferroni",
                        "BH"="BH",
                        "BY"="BY",
                        "fdr"="fdr",
                        "none"="none"))%>%helper(icon = "question",
                                                 colour = "green",
                                                 type = "markdown",
                                                 content = "Help_padjust",
                                                 style = "position:relative;left: 300px;top: -45px"),
          radioButtons("pval_RA", h3("Select P-Value threshold:"),
                       c("0.1" = 0.1,
                         "0.05" = 0.05,
                         "0.01" = 0.01,
                         "0.001" = 0.001),inline = TRUE),
          actionButton("calcRA","Calculate Result"),
          tags$hr(style="border-color: black;"),
          uiOutput("download_er_RA"),
          htmlOutput("EnrichResultTable_RA")%>%withSpinner(color="#0dc5c1")
        )#FluidRow
),#Item17 End
    tabItem(tabName = "GSEA_RA",
        fluidRow(
          radioButtons("pval_RA_gsea", h3("Select P-Value threshold:"),
                       c("0.1" = 0.1,
                         "0.05" = 0.05,
                         "0.01" = 0.01,
                         "0.001" = 0.001),inline = TRUE),
          selectInput("adj_gsea_RA",h3("Select adjustment method"),
                      c("holm"="holm",
                        "hochberg"="hochberg",
                        "hommel"="hommel",
                        "bonferroni"="bonferroni",
                        "BH"="BH",
                        "BY"="BY",
                        "fdr"="fdr",
                        "none"="none"))%>%helper(icon = "question",
                                                 colour = "green",
                                                 type = "markdown",
                                                 content = "Help_padjust",
                                                 style = "position:relative;left: 300px;top: -45px"),
          actionButton("calcRAGsea","Calculate Result"),
          tags$hr(style="border-color: black;"),
          uiOutput("download_er_RA_gsea"),
          htmlOutput("EnrichResultTable_RA_gsea")%>%withSpinner(color="#0dc5c1")
        )#FluidRow
), #Item18
#Bar Plot RA Tab
    tabItem(tabName = "BarPlot_RA",
        fluidRow(
          sliderInput("cat_barplotRA", "Number of categories",
                      min = 2, max = 30,  value = 15),
          imageOutput("BarPlot_RA2")%>%withSpinner(color="#0dc5c1"),
          box(title="Image download options",
              status = "primary",width=3,
              numericInput("wid_bp_ra","Width (pixel)",value=1600),
              numericInput("hei_bp_ra","Height (pixel)",value = 1200),
              numericInput("res_bp_ra","Resolution",value=300),
              numericInput("text_bp_ra","Text size",value=7),
              downloadButton("downloadBarPlotRA","Download Plot as .png"))

        )#FluidRow
      ), #Item19 End
#Dot Plot RA Tab
    tabItem(tabName = "DotPlot_RA",
        fluidRow(
          sliderInput("cat_dotplotRA", "Number of categories",
                      min = 2, max = 30,  value = 15),
          imageOutput("DotPlot_RA2")%>%withSpinner(color="#0dc5c1"),
          box(title="Image download options",
              status = "primary",width=3,
              numericInput("wid_dp_ra","Width (pixel)",value=1600),
              numericInput("hei_dp_ra","Height (pixel)",value = 1200),
              numericInput("res_dp_ra","Resolution",value=300),
              numericInput("text_dp_ra","Text size",value=7),
              downloadButton("downloadDotPlotRA","Download Plot as .png"))
        )#FluidRow
),#Item20 End
#Emapplot
tabItem(tabName = "Emap_RA",
        fluidRow(
          sliderInput("cat_emapplotRA", "Number of categories",
                      min = 0, max = 30,  value = 15),
          imageOutput("EmapPlot_RA2")%>%withSpinner(color="#0dc5c1"),
          box(title="Image download options",
              status = "primary",width=3,
              numericInput("wid_ep_ra","Width (pixel)",value=1600),
              numericInput("hei_ep_ra","Height (pixel)",value = 1200),
              numericInput("res_ep_ra","Resolution",value=300),
              downloadButton("downloadEmapPlotRA","Download Plot as .png"))

        )#FluidRow
),#Item21 End
tabItem(tabName = "cnetplot_RA",
        fluidRow(
          sliderInput("cat_cnetplotRA", "Number of categories",
                      min = 0, max = 30,  value = 15),
          imageOutput("CnetPlot_RA2")%>%withSpinner(color="#0dc5c1"),
          box(title="Image download options",
              status = "primary",width=3,
              numericInput("wid_cp_ra","Width (pixel)",value=1600),
              numericInput("hei_cp_ra","Height (pixel)",value = 1200),
              numericInput("res_cp_ra","Resolution",value=300),
              downloadButton("downloadCnetPlotRA","Download Plot as .png"))
        )#FluidRow
),#Item21 End
tabItem(tabName = "gsea_RA",
        fluidRow(
          htmlOutput("setsGseaRA"),
          imageOutput("GseaPlot_RA2")%>%withSpinner(color="#0dc5c1"),
          box(title="Image download options",
              status = "primary",width=3,
              numericInput("wid_gsp_ra","Width (pixel)",value=1600),
              numericInput("hei_gsp_ra","Height (pixel)",value = 1200),
              numericInput("res_gsp_ra","Resolution",value=300),
              downloadButton("downloadGseaPlotRA","Download Plot as .png"))
          )#FluidRow
),#Item22 End
tabItem(tabName = "path_RA",
        fluidRow(
          htmlOutput("setsPathRA"),
          actionButton("calcPathRA","Show path"),
          imageOutput("PathPlot_RA2")%>%withSpinner(color="#0dc5c1")),
          box(title="Image download options",
            status = "primary",width=3,
            numericInput("wid_pp_ra","Width (pixel)",value=1600),
            numericInput("hei_pp_ra","Height (pixel)",value = 1200),
            numericInput("res_pp_ra","Resolution",value=300),
            downloadButton("downloadPathPlotRA","Download Plot as .png"))
)
    )#Items
  )#Dashboard
)#Dashboard page

server <- function(input,output,session) {
  # uses 'helpfiles' directory by default
  # in this example, we use the withMathJax parameter to render formulae
  observe_helpers(withMathJax = TRUE)


  #Reading data
  geneList <- reactive({
        df<-read.csv(input$file1$datapath,
                      header = TRUE,
                      sep = ",")
        names(df)<-c("Entrez ID","FoldChange")
        df<-df[order(-df$FoldChange),]
        df$`Entrez ID`<-as.character(df$`Entrez ID`)
    return(df)
  })
  genes <- reactive({
    df<-read.csv(input$file2$datapath,
                 header = TRUE,
                 sep = ",")
    names(df)<-c("Entrez ID","FoldChange")
    df<-df[order(-df$FoldChange),]
    df$`Entrez ID`<-as.character(df$`Entrez ID`)
    return(df)
  })



##################################################################
##################################################################
##################################################################
###########################GO#####################################
  #Show first few rows
  output$TxtEnterdGenes<-renderText({
    req(input$file1)
    paste0("You uploaded: ",length(geneList()[,1])," genes")
  })

  output$data_preview<-renderText({
    req(input$file1)
    head(geneList(),10)%>%
      kable(caption="First 10 entries",format = "html", escape = F,digits = 3,row.names = FALSE)%>%
      kable_styling(c("striped"), full_width = F,fixed_thead = T,position = "left")

  })


  #Rendering text. How many selected genes?
  output$TxtSelectedGenes<-renderText({
    req(input$file2)
    paste0("You selected: ",length(genes()[,1])," genes")
  })
  output$data_preview2<-renderText({
    req(input$file2)
    head(genes(),10)%>%
      kable(caption="First 10 entries",format = "html", escape = F,digits = 3,row.names = FALSE)%>%
      kable_styling(c("striped"), full_width = F,fixed_thead = T,position = "left")

  })
  ######################################################################
  #Enrichment Specs GO
  enrichresgo<-eventReactive(input$calcGo,{
    ego <- enrichGO(gene          = genes()[,1],
                    universe      = geneList()[,1],
                    OrgDb         = input$specie_go,
                    ont           = input$ont_go,
                    pAdjustMethod = input$adj_go,
                    pvalueCutoff  = as.numeric(input$pval_go),
                    minGSSize = 5,
                    maxGSSize = 500,
                    qvalueCutoff  = 0.2,
                    readable      = TRUE)
  })
output$EnrichResultTable_GO<-renderText({
  enrichresgo()@result[,c(1:7,9,8)]%>%
    filter(p.adjust<=as.numeric(input$pval_go))%>%
    mutate(
      p.adjust = color_tile("green", "red")(formatC(p.adjust,format = "e",digits = 2)),
      Count=color_bar("lightgreen")(Count)
    )%>%
  dplyr::select(everything()) %>%
    kable(format = "html", escape = F,digits = 3,row.names = FALSE)%>%
    kable_styling(c("striped","hover"), full_width = F,fixed_thead = T)%>%
    scroll_box(width = "900px", height = "600px")

})
output$download_er_go <- renderUI({
  req(enrichresgo())
  downloadButton("EnrichResultTableGoDownload","Download Results as .csv")%>%helper(icon = "question",
                                                                                    colour = "green",
                                                                                    type = "markdown",
                                                                                    content = "ORAOutput",
                                                                                    style = "position:relative;left: 220px;top: -27px")
})
output$EnrichResultTableGoDownload<-downloadHandler(
  filename =function(){
    paste0("EnrichmentResult_GO",".csv",sep="")
  },
  content = function(file){
  write.csv(enrichresgo(),file,row.names = FALSE)
  }
)
######################################################################
#GSEA GO
enrichresgo_gsea<-eventReactive(input$calcGoGsea,{
  geneListv<-geneList()[,2]
  names(geneListv)<-geneList()[,1]
  ego2 <- gseGO(geneList     = geneListv,
                       OrgDb        = input$specie_go,
                       ont          = input$ont_go_gsea,
                       nPerm        = 1000,
                       minGSSize    = 5,
                       maxGSSize    = 500,
                       pAdjustMethod = input$adj_gsea_go,
                       pvalueCutoff = as.numeric(input$pval_go_gsea),
                       verbose      = FALSE)
})
output$EnrichResultTable_GO_gsea<-renderText({
  enrichresgo_gsea()@result%>%
    filter(p.adjust<=as.numeric(input$pval_go_gsea))%>%
    mutate(
      p.adjust = color_tile("green", "red")(formatC(p.adjust,format = "e",digits = 2))
    )%>%
    dplyr::select(everything()) %>%
    kable(format = "html", escape = F,digits = 3,row.names = FALSE)%>%
    kable_styling(c("striped","hover"), full_width = F,fixed_thead = T)%>%
    scroll_box(width = "900px", height = "600px")
})
output$download_er_go_gsea <- renderUI({
  req(enrichresgo_gsea())
  downloadButton("EnrichResultTableGoGseaDownload","Download Results as .csv")%>%helper(icon = "question",
                                                                                        colour = "green",
                                                                                        type = "markdown",
                                                                                        content = "GSEA_Output",
                                                                                        style = "position:relative;left: 220px;top: -27px")
})
output$EnrichResultTableGoGseaDownload<-downloadHandler(
  filename =function(){
    paste0("EnrichmentResult_GSEA_GO",".csv",sep="")
  },
  content = function(file){
    write.csv(enrichresgo_gsea(),file,row.names = FALSE)
  })

##################################
###########BarPlotGO##############
output$BarPlot_GO2<-renderImage({
  # A temp file to save the output.
  # This file will be removed later by renderImage
  outfile <- tempfile(fileext = '.png')

  # Generate the PNG
  png(outfile, width = 700, height =400)
  print(barplot(enrichresgo(), showCategory = input$cat_barplotgo, font.size = 7,
          title = paste0("GO Pathway Analysis",". Barplot")))
  dev.off()

  # Return a list containing the filename
  list(src = outfile,
       contentType = 'image/png',
       width = 700,
       height = 400,
       alt = "This is alternate text")
}, deleteFile = TRUE)

output$downloadBarPlotGo <- downloadHandler(
  filename = "BarPlot.png",
  content = function(file) {
    png(file,width =input$wid_bp_go, height = input$hei_bp_go,res=input$res_bp_go)
    print(barplot(enrichresgo(), showCategory = input$cat_barplotgo, font.size = input$text_bp_go,
                  title = paste0("GO Pathway Analysis",". Barplot")))
    dev.off()
  })
##################################
###########DotPlotGO##############
output$DotPlot_GO2<-renderImage({
  # A temp file to save the output.
  # This file will be removed later by renderImage
  outfile <- tempfile(fileext = '.png')

  # Generate the PNG
  png(outfile, width = 700, height = 400)
  print(dotplot(enrichresgo(), showCategory = input$cat_dotplotgo, font.size = 7,
                title = paste0("GO Pathway Analysis",". Barplot")))
  dev.off()

  # Return a list containing the filename
  list(src = outfile,
       contentType = 'image/png',
       width = 700,
       height = 400,
       alt = "This is alternate text")
}, deleteFile = TRUE)

output$downloadDotPlotGo <- downloadHandler(
  filename = "DotPlot.png",
  content = function(file) {
    png(file,width = input$wid_dp_go, height = input$hei_dp_go,res=input$res_dp_go)
    print(dotplot(enrichresgo(), showCategory = input$cat_dotplotgo, font.size = input$text_dp_go,
                  title = paste0("GO Pathway Analysis",". Dotplot")))
    dev.off()
  })

##################################
###########EmapPlotGO##############
output$EmapPlot_GO2<-renderImage({
  # A temp file to save the output.
  # This file will be removed later by renderImage
  outfile <- tempfile(fileext = '.png')

  # Generate the PNG
  png(outfile, width=700,height = 400)
  print(emapplot(enrichresgo(), showCategory = input$cat_emapplotgo, font.size = 7,
                title = paste0("GO Pathway Analysis",". Barplot")))
  dev.off()

  # Return a list containing the filename
  list(src = outfile,
       contentType = 'image/png',
       width = 700,
       height = 400,
       res=input$res_bp_go,
       alt = "This is alternate text")
}, deleteFile = TRUE)

output$downloadEmapPlotGo <- downloadHandler(
  filename = "EmapPlot.png",
  content = function(file) {
    png(file,width = input$wid_ep_go, height = input$hei_ep_go,res=input$res_ep_go)
    print(emapplot(enrichresgo(), showCategory = input$cat_emapplotgo,
                  title = paste0("GO Pathway Analysis",". Emapplot")))
    dev.off()
  })

##################################
###########CnetPlotGO##############
output$CnetPlot_GO2<-renderImage({
  # A temp file to save the output.
  # This file will be removed later by renderImage
  outfile <- tempfile(fileext = '.png')

  # Generate the PNG
  png(outfile, width = 700, height = 400)
  print(cnetplot(enrichresgo(), showCategory = input$cat_cnetplotgo, font.size = 7,
                 title = paste0("GO Pathway Analysis",". Category-gene-network")))
  dev.off()

  # Return a list containing the filename
  list(src = outfile,
       contentType = 'image/png',
       width = 700,
       height = 400,
       alt = "This is alternate text")
}, deleteFile = TRUE)

output$downloadCnetPlotGo <- downloadHandler(
  filename = "CnetPlot.png",
  content = function(file) {
    png(file,width = input$wid_cp_go, height = input$hei_cp_go,res=input$res_cp_go)
    print(cnetplot(enrichresgo(), showCategory = input$cat_cnetplotgo,
                   title = paste0("GO Pathway Analysis",". Category-gene-network")))
    dev.off()
  })

##################################
###########GoPlotGO##############
output$GoPlot_GO2<-renderImage({
  # A temp file to save the output.
  # This file will be removed later by renderImage
  outfile <- tempfile(fileext = '.png')

  # Generate the PNG
  png(outfile, width = 700, height = 400)
  print(goplot(enrichresgo(), showCategory = input$cat_goplotgo, font.size = 7,
                 title = paste0("GO Pathway Analysis",". Go Plot")))
  dev.off()

  # Return a list containing the filename
  list(src = outfile,
       contentType = 'image/png',
       width = 700,
       height = 400,
       alt = "This is alternate text")
}, deleteFile = TRUE)

output$downloadGoPlotGo <- downloadHandler(
  filename = "GoPlot.png",
  content = function(file) {
    png(file,width = input$wid_gp_go, height = input$hei_gp_go,res=input$res_gp_go)
    print(goplot(enrichresgo(), showCategory = input$cat_goplotgo,
                   title = paste0("GO Pathway Analysis",". Go Plot")))
    dev.off()
  })

##################################
###########GseaPlotGO##############
output$setsGseaGo <- renderUI({
  selectInput("geneSetGseaGo", "Select gene set", enrichresgo_gsea()@result$Description)
})
output$GseaPlot_GO2<-renderImage({
  # A temp file to save the output.
  # This file will be removed later by renderImage
  outfile <- tempfile(fileext = '.png')

  # Generate the PNG
  png(outfile, width = 700, height = 400)
  print(gseaplot(enrichresgo_gsea(), geneSetID = enrichresgo_gsea()@result$ID[enrichresgo_gsea()@result$Description==input$geneSetGseaGo]))
  dev.off()

  # Return a list containing the filename
  list(src = outfile,
       contentType = 'image/png',
       width = 700,
       height = 400,
       alt = "This is alternate text")
}, deleteFile = TRUE)

output$downloadGseaPlotGo <- downloadHandler(
  filename = "GseaPlot.png",
  content = function(file) {
    png(file,input$wid_gsp_go, height = input$hei_gsp_go,res=input$res_gsp_go)
    print(gseaplot(enrichresgo_gsea(), geneSetID = enrichresgo_gsea()@result$ID[enrichresgo_gsea()@result$Description==input$geneSetGseaGo]))
    dev.off()
  })

##################################################################
##################################################################
##################################################################
###########################KEGG###################################

######################################################################
#Enrichment Specs

kegg_organism1<-reactive({
org<-search_kegg_organism(input$searchKEGGspecie,by='scientific_name', ignore.case = TRUE)
})
output$SelSpecieKEGG <- renderUI({
selectInput("specieKEGG", "Select KEGG Specie",kegg_organism1()$scientific_name)
})
kegg_organism2<-function(){
  kegg_species$kegg_code[kegg_species$scientific_name==input$specieKEGG]
}
#http://www.genome.jp/kegg/catalog/org_list.html

enrichreskegg<-eventReactive(input$calcKEGG,{
  kk <- enrichKEGG(gene         = genes()[,1],
                   organism     = kegg_organism2(),
                   pvalueCutoff = as.numeric(input$pval_kegg),
                   pAdjustMethod =input$adj_kegg,
                   minGSSize = 10,
                   maxGSSize = 500)
})
output$EnrichResultTable_KEGG<-renderText({
  enrichreskegg()@result[,c(1:7,9,8)]%>%
    filter(p.adjust<=as.numeric(input$pval_kegg))%>%
    mutate(
      p.adjust = color_tile("green", "red")(formatC(p.adjust,format = "e",digits = 2)),
      Count=color_bar("lightgreen")(Count)
    )%>%
    dplyr::select(everything()) %>%
    kable(format = "html", escape = F,digits = 3,row.names = FALSE)%>%
    kable_styling(c("striped","hover"), full_width = F,fixed_thead = T)%>%
    scroll_box(width = "900px", height = "600px")

})
output$download_er_kegg <- renderUI({
  req(enrichreskegg())
  downloadButton("EnrichResultTableKeggDownload","Download Results as .csv")%>%helper(icon = "question",
                                                                                      colour = "green",
                                                                                      type = "markdown",
                                                                                      content = "ORAOutput",
                                                                                      style = "position:relative;left: 220px;top: -27px")
})
output$EnrichResultTableKeggDownload<-downloadHandler(
  filename =function(){
    paste0("EnrichmentResult_Kegg",".csv",sep="")
  },
  content = function(file){
    write.csv(enrichreskegg(),file,row.names = FALSE)
  }
)
############################################################################
#GSEA KEGG
enrichreskegg_gsea<-eventReactive(input$calcKeggGsea,{
  geneListv<-geneList()[,2]
  names(geneListv)<-geneList()[,1]
  kk2 <- gseKEGG(geneList     = geneListv,
               organism     = kegg_organism2(),
               nPerm        = 1000,
               pAdjustMethod = input$adj_gsea_kegg,
               pvalueCutoff = as.numeric(input$pval_kegg_gsea),
               minGSSize = 5,
               maxGSSize = 500,
               verbose      = FALSE)
})
output$EnrichResultTable_KEGG_gsea<-renderText({
  enrichreskegg_gsea()@result%>%
    filter(p.adjust<=as.numeric(input$pval_kegg_gsea))%>%
    mutate(
      p.adjust = color_tile("green", "red")(formatC(p.adjust,format = "e",digits = 2))
    )%>%
    dplyr::select(everything()) %>%
    kable(format = "html", escape = F,digits = 3,row.names = FALSE)%>%
    kable_styling(c("striped","hover"), full_width = F,fixed_thead = T)%>%
    scroll_box(width = "900px", height = "600px")
})
output$download_er_kegg_gsea <- renderUI({
  req(enrichreskegg_gsea())
  downloadButton("EnrichResultTableKeggGseaDownload","Download Results as .csv")%>%helper(icon = "question",
                                                                                          colour = "green",
                                                                                          type = "markdown",
                                                                                          content = "GSEA_Output",
                                                                                          style = "position:relative;left: 220px;top: -27px")
})
output$EnrichResultTableKeggGseaDownload<-downloadHandler(
  filename =function(){
    paste0("EnrichmentResult_GSEA_KEGG",".csv",sep="")
  },
  content = function(file){
    write.csv(enrichreskegg_gsea(),file,row.names = FALSE)
  })

##################################
###########BarPlotKEGG##############
output$BarPlot_KEGG2<-renderImage({
  # A temp file to save the output.
  # This file will be removed later by renderImage
  outfile <- tempfile(fileext = '.png')

  # Generate the PNG
  png(outfile, width = 700, height = 400)
  print(barplot(enrichreskegg(), showCategory = input$cat_barplotkegg, font.size = 7,
                title = paste0("KEGG Pathway Analysis",". Barplot")))
  dev.off()

  # Return a list containing the filename
  list(src = outfile,
       contentType = 'image/png',
       width = 700,
       height = 400,
       alt = "This is alternate text")
}, deleteFile = TRUE)

output$downloadBarPlotKegg <- downloadHandler(
  filename = "BarPlotKEGG.png",
  content = function(file) {
    png(file,width = input$wid_bp_kegg, height = input$hei_bp_kegg,res=input$res_bp_kegg)
    print(barplot(enrichreskegg(), showCategory = input$cat_barplotkegg, font.size = input$text_bp_kegg,
                  title = paste0("KEGG Pathway Analysis",". Barplot")))
    dev.off()
  })


##################################
###########DotPlotKEGG##############
output$DotPlot_KEGG2<-renderImage({
  # A temp file to save the output.
  # This file will be removed later by renderImage
  outfile <- tempfile(fileext = '.png')

  # Generate the PNG
  png(outfile, width = 700, height = 400)
  print(dotplot(enrichreskegg(), showCategory = input$cat_dotplotkegg, font.size = 7,
                title = paste0("KEGG Pathway Analysis",". Barplot")))
  dev.off()

  # Return a list containing the filename
  list(src = outfile,
       contentType = 'image/png',
       width = 700,
       height = 400,
       alt = "This is alternate text")
}, deleteFile = TRUE)

output$downloadDotPlotKegg <- downloadHandler(
  filename = "DotPlotKegg.png",
  content = function(file) {
    png(file,width = input$wid_dp_kegg, height = input$hei_dp_kegg,res=input$res_dp_kegg)
    print(dotplot(enrichrekegg(), showCategory = input$cat_dotplotkegg, font.size = input$res_dp_kegg,
                  title = paste0("KEGG Pathway Analysis",". Dotplot")))
    dev.off()
  })

##################################
###########EmapPlotKEGG##############
output$EmapPlot_KEGG2<-renderImage({
  # A temp file to save the output.
  # This file will be removed later by renderImage
  outfile <- tempfile(fileext = '.png')

  # Generate the PNG
  png(outfile, width = 700, height = 400)
  print(emapplot(enrichreskegg(), showCategory = input$cat_emapplotkegg, font.size = 7,
                 title = paste0("KEGG Pathway Analysis",". Barplot")))
  dev.off()

  # Return a list containing the filename
  list(src = outfile,
       contentType = 'image/png',
       width = 700,
       height = 400,
       alt = "This is alternate text")
}, deleteFile = TRUE)

output$downloadEmapPlotKegg <- downloadHandler(
  filename = "EmapPlotKEGG.png",
  content = function(file) {
    png(file,width = input$wid_ep_kegg, height = input$hei_ep_kegg,res=input$res_ep_kegg)
    print(emapplot(enrichreskegg(), showCategory = input$cat_emapplotkegg,
                   title = paste0("KEGG Pathway Analysis",". Emapplot")))
    dev.off()
  })

##################################
###########CnetPlotKEGG##############
output$CnetPlot_KEGG2<-renderImage({
  # A temp file to save the output.
  # This file will be removed later by renderImage
  outfile <- tempfile(fileext = '.png')

  # Generate the PNG
  png(outfile, width = 700, height = 400)
  print(cnetplot(enrichreskegg(), showCategory = input$cat_cnetplotkegg, font.size = 7,
                 title = paste0("KEGG Pathway Analysis",". Category-gene-network")))
  dev.off()

  # Return a list containing the filename
  list(src = outfile,
       contentType = 'image/png',
       width = 700,
       height = 400,
       alt = "This is alternate text")
}, deleteFile = TRUE)

output$downloadCnetPlotKegg <- downloadHandler(
  filename = "CnetPlotKEGG.png",
  content = function(file) {
    png(file,width = input$wid_cp_kegg, height = input$hei_cp_kegg,res=input$res_cp_kegg)
    print(cnetplot(enrichreskegg(), showCategory = input$cat_cnetplotkegg,
                   title = paste0("KEGG Pathway Analysis",". Category-gene-network")))
    dev.off()
  })


##################################
###########GseaPlotGO##############
output$setsGseaKegg <- renderUI({
  selectInput("geneSetGseaKegg", "Select gene set", enrichreskegg_gsea()@result$Description)
})
output$GseaPlot_KEGG2<-renderImage({
  # A temp file to save the output.
  # This file will be removed later by renderImage
  outfile <- tempfile(fileext = '.png')

  # Generate the PNG
  png(outfile, width = 700, height = 400)
  print(gseaplot(enrichreskegg_gsea(), geneSetID = enrichreskegg_gsea()@result$ID[enrichreskegg_gsea()@result$Description==input$geneSetGseaKegg]))
  dev.off()

  # Return a list containing the filename
  list(src = outfile,
       contentType = 'image/png',
       width = 700,
       height = 400,
       alt = "This is alternate text")
}, deleteFile = TRUE)

output$downloadGseaPlotKegg <- downloadHandler(
  filename = "GseaPlotKEGG.png",
  content = function(file) {
    png(file,input$wid_gsp_kegg, height = input$hei_gsp_kegg,res=input$res_gsp_kegg)
    print(gseaplot(enrichreskegg_gsea(), geneSetID = enrichreskegg_gsea()@result$ID[enrichreskegg_gsea()@result$Description==input$geneSetGseaKegg]))
    dev.off()
  })
<<<<<<< HEAD
=======

>>>>>>> f718be5bbd710b3ea41a419f4e83e287eb9bd0ae
###################################
##########Pathway_KEGG############
output$PathKeggUi <- renderUI({
  selectInput("PathKegg", "Select gene set", enrichreskegg()@result$Description[enrichreskegg()@result$p.adjust<=as.numeric(input$pval_kegg)])
})
# path.id<-reactive({
#   enrichreskegg()@result$ID[enrichreskegg()@result$Description==input$PathKegg]
#   })

output$pathway_KEGG2<-renderImage({
  req(enrichreskegg())
  geneListv<-geneList()[,2]
  names(geneListv)<-geneList()[,1]
<<<<<<< HEAD
  path.id<-enrichreskegg()@result$ID[enrichreskegg()@result$Description==input$PathKegg]
  pathviewPatched::pathview(gene.data  = geneListv,
                            pathway.id = path.id,
                            kegg.dir = paste0(tempdir(),"\\"),
                            species    =  kegg_organism2(),
                            limit      = list(gene=max(abs(geneListv)), cpd=1))
=======
 path.id<-enrichreskegg()@result$ID[enrichreskegg()@result$Description==input$PathKegg]
 pathviewPatched::pathview(gene.data  = geneListv,
           pathway.id = path.id,
           kegg.dir = paste0(tempdir(),"\\"),
           species    =  kegg_organism2(),
           limit      = list(gene=max(abs(geneListv)), cpd=1))
>>>>>>> f718be5bbd710b3ea41a419f4e83e287eb9bd0ae

  img <- readPNG(paste0(tempdir(),"\\",path.id,".pathview.png"))
  width <- ncol(img)*0.5
  height <- nrow(img)*0.5

  list(src = paste0(tempdir(),"\\",path.id,".pathview.png"),
       contentType = 'image/png',
       width = width,
       height = height,
       alt = "Something wrong")
}, deleteFile = TRUE)

output$downloadPathKegg <- downloadHandler(
  filename = "Test.png",
  content = function(file) {
    geneListv<-geneList()[,2]
    names(geneListv)<-geneList()[,1]
    path.id<-enrichreskegg()@result$ID[enrichreskegg()@result$Description==input$PathKegg]
    pathviewPatched::pathview(gene.data  = geneListv,
<<<<<<< HEAD
                              pathway.id = path.id,
                              kegg.dir = paste0(tempdir(),"\\"),
                              species    =  kegg_organism2(),
                              limit      = list(gene=max(abs(geneListv)), cpd=1))
    file.copy(paste0(tempdir(),"\\",path.id,".pathview.png"), file)
  }, contentType = 'image/png')


=======
             pathway.id = path.id,
             kegg.dir = paste0(tempdir(),"\\"),
             species    =  kegg_organism2(),
             limit      = list(gene=max(abs(geneListv)), cpd=1))
    file.copy(paste0(tempdir(),"\\",path.id,".pathview.png"), file)
  }, contentType = 'image/png')

>>>>>>> f718be5bbd710b3ea41a419f4e83e287eb9bd0ae
##################################################################
##################################################################
##################################################################
#########################REACTOME#################################

#Enrichment Specs Reactome
enrichresRA<-eventReactive(input$calcRA,{
  eRA <- enrichPathway(gene          = genes()[,1],
                  organism      = input$specie,
                  pAdjustMethod = input$adj_RA,
                  pvalueCutoff  = as.numeric(input$pval_RA),
                  qvalueCutoff  = 0.05,
                  readable      = TRUE,
                  minGSSize = 5,
                  maxGSSize = 500)
})
##########################################################
output$EnrichResultTable_RA<-renderText({
  enrichresRA()@result[,c(1:7,9,8)]%>%
    filter(p.adjust<=as.numeric(input$pval_RA))%>%
    mutate(
      p.adjust = color_tile("green", "red")(formatC(p.adjust,format = "e",digits = 2)),
      Count=color_bar("lightgreen")(Count)
    )%>%
    dplyr::select(everything()) %>%
    kable(format = "html", escape = F,digits = 3,row.names = FALSE)%>%
    kable_styling(c("striped","hover"), full_width = F,fixed_thead = T)%>%
    scroll_box(width = "900px", height = "600px")

})
output$download_er_RA<- renderUI({
  req(enrichresRA())
  downloadButton("EnrichResultTableRADownload","Download Results as .csv")%>%helper(icon = "question",
                                                                                    colour = "green",
                                                                                    type = "markdown",
                                                                                    content = "ORAOutput",
                                                                                    style = "position:relative;left: 220px;top: -27px")
})
output$EnrichResultTableRADownload<-downloadHandler(
  filename =function(){
    paste0("EnrichmentResult_RA",".csv",sep="")
  },
  content = function(file){
    write.csv(enrichresRA(),file,row.names = FALSE)
  }
)
#GSEA
enrichresRA_gsea<-eventReactive(input$calcRAGsea,{
  geneListv<-geneList()[,2]
  names(geneListv)<-geneList()[,1]
  geneListv<-sort(geneListv,decreasing = TRUE)
  ego2 <- gsePathway(geneList     = geneListv,
                organism          = input$specie,
                nPerm        = 1000,
                minGSSize    = 5,
                maxGSSize    = 500,
                pAdjustMethod = input$adj_gsea_RA,
                pvalueCutoff = as.numeric(input$pval_RA_gsea),
                verbose      = FALSE)
})
output$EnrichResultTable_RA_gsea<-renderText({
  enrichresRA_gsea()@result%>%
    filter(p.adjust<=as.numeric(input$pval_RA_gsea))%>%
    mutate(
      p.adjust = color_tile("green", "red")(formatC(p.adjust,format = "e",digits = 2))
    )%>%
    dplyr::select(everything()) %>%
    kable(format = "html", escape = F,digits = 3,row.names = FALSE)%>%
    kable_styling(c("striped","hover"), full_width = F,fixed_thead = T)%>%
    scroll_box(width = "900px", height = "600px")
})
output$download_er_RA_gsea <- renderUI({
  req(enrichresRA_gsea())
  downloadButton("EnrichResultTableRAGseaDownload","Download Results as .csv")%>%helper(icon = "question",
                                                                                        colour = "green",
                                                                                        type = "markdown",
                                                                                        content = "GSEA_Output",
                                                                                        style = "position:relative;left: 220px;top: -27px")
})
output$EnrichResultTableRAGseaDownload<-downloadHandler(
  filename =function(){
    paste0("EnrichmentResult_GSEA_RA",".csv",sep="")
  },
  content = function(file){
    write.csv(enrichresRA_gsea(),file,row.names = FALSE)
  })

##################################
###########BarPlotRA##############
output$BarPlot_RA2<-renderImage({
  # A temp file to save the output.
  # This file will be removed later by renderImage
  outfile <- tempfile(fileext = '.png')

  # Generate the PNG
  png(outfile, width = 700, height = 400)
  print(barplot(enrichresRA(), showCategory = input$cat_barplotRA, font.size = 7,
                title = paste0("Reactome Pathway Analysis",". Barplot")))
  dev.off()

  # Return a list containing the filename
  list(src = outfile,
       contentType = 'image/png',
       width = 700,
       height = 400,
       alt = "This is alternate text")
}, deleteFile = TRUE)

output$downloadBarPlotRA <- downloadHandler(
  filename = "BarPlotRA.png",
  content = function(file) {
    png(file,width = input$wid_bp_ra, height = input$hei_bp_ra,res=input$res_bp_ra)
    print(barplot(enrichresRA(), showCategory = input$cat_barplotRA, font.size = input$text_bp_ra,
                  title = paste0("Reactome Pathway Analysis",". Barplot")))
    dev.off()
  })

##################################
###########DotPlotRA##############
output$DotPlot_RA2<-renderImage({
  # A temp file to save the output.
  # This file will be removed later by renderImage
  outfile <- tempfile(fileext = '.png')

  # Generate the PNG
  png(outfile, width = 700, height = 400)
  print(dotplot(enrichresRA(), showCategory = input$cat_dotplotRA, font.size = 7,
                title = paste0("Reactome Pathway Analysis",". Barplot")))
  dev.off()

  # Return a list containing the filename
  list(src = outfile,
       contentType = 'image/png',
       width = 700,
       height = 400,
       alt = "This is alternate text")
}, deleteFile = TRUE)

output$downloadDotPlotRA <- downloadHandler(
  filename = "DotPlotRA.png",
  content = function(file) {
    png(file,width = input$wid_dp_ra, height = input$hei_dp_ra,res=input$res_dp_ra)
    print(dotplot(enrichresRA(), showCategory = input$cat_dotplotRA, font.size = input$text_dp_ra,
                  title = paste0("Reactome Pathway Analysis",". Dotplot")))
    dev.off()
  })

##################################
###########EmapPlotRA##############
output$EmapPlot_RA2<-renderImage({
  # A temp file to save the output.
  # This file will be removed later by renderImage
  outfile <- tempfile(fileext = '.png')

  # Generate the PNG
  png(outfile, width = 700, height = 400)
  print(emapplot(enrichresRA(), showCategory = input$cat_emapplotRA, font.size = 7,
                 title = paste0("RA Pathway Analysis",". Barplot")))
  dev.off()

  # Return a list containing the filename
  list(src = outfile,
       contentType = 'image/png',
       width = 700,
       height = 400,
       alt = "This is alternate text")
}, deleteFile = TRUE)

output$downloadEmapPlotRA <- downloadHandler(
  filename = "EmapPlotRA.png",
  content = function(file) {
    png(file,width = input$wid_ep_ra, height = input$hei_ep_ra,res=input$res_ep_ra)
    print(emapplot(enrichresRA(), showCategory = input$cat_emapplotRA, font.size = 7,
                   title = paste0("Reactome Pathway Analysis",". Emapplot")))
    dev.off()
  })
##################################
###########CnetPlotRA##############
output$CnetPlot_RA2<-renderImage({
  req(input$file2)
  geneListv<-geneList()[,2]
  names(geneListv)<-geneList()[,1]
  # A temp file to save the output.
  # This file will be removed later by renderImage
  outfile <- tempfile(fileext = '.png')

  # Generate the PNG
  png(outfile, width = 700, height = 400)
  print(cnetplot(enrichresRA(), foldChange=geneListv,showCategory = input$cat_cnetplotRA, font.size = 7,
                 title = paste0("RA Pathway Analysis",". Category-gene-network")))
  dev.off()

  # Return a list containing the filename
  list(src = outfile,
       contentType = 'image/png',
       width = 700,
       height = 400,
       alt = "This is alternate text")
}, deleteFile = TRUE)

output$downloadCnetPlotRA <- downloadHandler(
  filename = "CnetPlotRA.png",
  content = function(file) {
    req(geneList())
    req(enrichresRA())
    geneListv<-geneList()[,2]
    names(geneListv)<-geneList()[,1]
    # Generate the PNG
    png(file,width = input$wid_cp_ra, height = input$hei_cp_ra,res=input$res_cp_ra)
    print(cnetplot(enrichresRA(), foldChange=geneListv,showCategory = input$cat_cnetplotRA, font.size = 7,
                   title = paste0("RA Pathway Analysis",". Category-gene-network")))
    dev.off()
  })

##################################
###########GseaPlotRA##############
output$setsGseaRA <- renderUI({
  selectInput("geneSetGseaRA", "Select gene set", enrichresRA_gsea()@result$Description)
})
output$GseaPlot_RA2<-renderImage({
  # A temp file to save the output.
  # This file will be removed later by renderImage
  outfile <- tempfile(fileext = '.png')

  # Generate the PNG
  png(outfile, width = 700, height = 400)
  print(gseaplot(enrichresRA_gsea(), geneSetID = enrichresRA_gsea()@result$ID[enrichresRA_gsea()@result$Description==input$geneSetGseaRA]))
  dev.off()

  # Return a list containing the filename
  list(src = outfile,
       contentType = 'image/png',
       width = 700,
       height = 400,
       alt = "This is alternate text")
}, deleteFile = TRUE)

output$downloadGseaPlotRA <- downloadHandler(
  filename = "GseaPlot.png",
  content = function(file) {
    png(file,width = input$wid_gsp_ra, height = input$hei_gsp_ra,res=input$res_gsp_ra)
    print(gseaplot(enrichresRA_gsea(), geneSetID = enrichresRA_gsea()@result$ID[enrichresRA_gsea()@result$Description==input$geneSetGseaRA]))
    dev.off()
  })

##################################
###########PathPlotRA##############
output$setsPathRA <- renderUI({
  selectInput("geneSetPathRA", "Select gene set", enrichresRA()@result$Description)
})



PathPlotRA<-eventReactive(input$calcPathRA,{
  geneListv<-geneList()[,2]
  names(geneListv)<-geneList()[,1]
  MyPlot<-viewPathway(input$geneSetPathRA,readable=TRUE, foldChange=geneListv,organism=input$specie)
})


output$PathPlot_RA2<-renderImage({
  # For high-res displays, this will be greater than 1
  pixelratio <- session$clientData$pixelratio

  outfile <- tempfile(fileext = '.png')
  png(outfile, width = 700, height = 400)
  print(PathPlotRA())
  dev.off()
  # Return a list containing the filename
  list(src = outfile,
       contentType = 'image/png',
       width = 700,
       height = 400,
       alt = "This is alternate text")
}, deleteFile = TRUE)


output$downloadPathPlotRA<- downloadHandler(
  filename = "PathPlotRA.png",
  content = function(file) {
    png(file,width = input$wid_pp_ra, height = input$hei_pp_ra,res=input$res_pp_ra)
    print(PathPlotRA())
    dev.off()
  })
}
shinyApp(ui, server)

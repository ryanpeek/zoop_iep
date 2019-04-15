
# dynamic ui
shinyUI(navbarPage(theme=shinytheme("yeti"),
                   title=HTML('<div><a href="http://watershed.ucdavis.edu" target="_blank">
             <img src="https://watershed.ucdavis.edu/files/cws_logo_48.png" width="100%"></a></div>'),
                   
                   tabPanel("Zoop IEP",value="zoopIEP"),
                   tabPanel("Data View", value="datView"),
                   tabPanel("About", value="about"),
                   
                   windowTitle="Zoops",
                   collapsible=TRUE,
                   id="tab",
                   tags$head(tags$link(rel="stylesheet", type="text/css", href="styles.css")),
                   
                   # first panel of sites and date range
                   conditionalPanel("input.tab=='zoopIEP'",
                                    fluidRow(
                                      column(4, h2("Zoop IEP Map"), h3("Explore the IEP Stations")),
                                      column(8, h3("Range of available data for period of record"),
                                             fluidRow(
                                               column(4,
                                                      selectInput("station", label = "Station",
                                                                  selected = NULL,
                                                                  choices = c("None", site_choices), 
                                                                  width="100%", 
                                                                  multiple = F)
                                               )
                                             ))
                                    ),
                                    bsTooltip(id = "station", title = "Enter a station. The menu will filter as you type. You can also select from the map.", placement = "top", options = list(container="body")),
                                    fluidRow(
                                      column(4, leafletOutput("map")),
                                      column(8, plotOutput("plotRange"))
                                    )
                   ),
                   
                   # second panel of data viewer for taxa
                   conditionalPanel("input.tab=='datView'",
                                    fluidRow(
                                      column(4, h2(HTML("<a href='http://www.dfg.ca.gov/delta/projects.asp?ProjectID=ZOOPLANKTON' target=_blank>Zoop IEP Data</a>")), h3("Explore IEP CB Variables")),
                                      column(8, 
                                             fluidRow(
                                               column(6,
                                                      selectInput("variables",
                                                                  label = "Select columns to display",
                                                                  choices = c(varNames),
                                                                  selectize = FALSE, 
                                                                  selected = "DAPHNIA", 
                                                                  width="100%", multiple = F)
                                               ),
                                               column(2,
                                                      checkboxInput("logscale", 
                                                                    label = "Log Scale?", value = TRUE)
                                               ),
                                               column(2, 
                                                      selectInput('facet_row', label = 'Facet Row', 
                                                                  choices= c(None=".", Year="Year", Survey="Survey"), 
                                                                  multiple = FALSE)
                                               ),
                                               column(2,
                                                      selectInput('facet_col', label= 'Facet Col', 
                                                                  choices=c(None=".", Year="Year", Survey="Survey"))
                                               )
                                             ),
                                             fluidRow(
                                               column(4,
                                                      selectInput("yr_range", label = "Year Range",
                                                                  choices = c(seq(1972,2017,1)),
                                                                  selected = 1978, multiple = TRUE)
                                               ),
                                               column(4,
                                                      selectInput("mon_range", label = "Month Range", 
                                                                  choices = c(seq(1,12,1)), selected = 3,
                                                                  multiple = TRUE)
                                               )
                                             )
                                      )
                                    ),
                                    bsTooltip("variables", "Select a taxa/group of interest.", "top", options = list(container="body")),
                                    bsTooltip("logscale", "Check this box to log scale the data.", "top", options = list(container="body")),
                                    bsTooltip("yr_range", "Select the year or years of interest. You can select as many as you like.", "top", options = list(container="body")),
                                    bsTooltip("mon_range", "Select the months of interest.", "top", options = list(container="body")),
                                    fluidRow(
                                      column(4, plotOutput("map2")),
                                      column(8, plotOutput("plotData"))
                                    )
                   ),
                   
                   conditionalPanel("input.tab=='about'", source("about.R",local=T)$value)
)
)

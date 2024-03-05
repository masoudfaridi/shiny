#' module_1_2 UI Function
#' @description A shiny Module.
#' @param id,input,output,session Internal parameters for {shiny}.
#' @noRd
#' @import shiny
#' @import RPostgres
#' @import DBI
#' @import odbc
#' @import DT
#' @import plotly
#' @import dplyr
#' @import bsts
#' @import shinycssloaders
#' @import shinybusy

mod_module_1_2_ui <- function(id){
  ns <- NS(id)
  tagList(
##########################################################################################
################################  start tagList  ###########################################
##########################################################################################
shinydashboardPlusbox_MF(
  #shinydashboardPlus::box(
  title = h5('\u0639\u0646\u0648\u0627\u0646'
             ,class ="h1t2"
  ),
  id = ns("settings_shinydashboardPlusbox_MF1"),
  closable = TRUE,
  width = 12,
  height = "2000px",
  solidHeader = FALSE,
  collapsible = TRUE
  ,sidebar = shinydashboardPlus::boxSidebar(
    id = ns("settings_plt1"),
    width = 25
    ,tagList(

      sliderInput(
        ns("settings_line_size"),
        "line size(plotly):",
        min = 0,
        max = 10,
        value = 2,step =0.25
      )
      ,

      sliderInput(
        ns("settings_marker_size"),
        "marker size(plotly):",
        min = 1,
        max = 50,
        value = 15,step =1
      )
      ,
      sliderInput(
        ns("settings_plot_gis_height"),
        "marker size(plot):",
        min = 10000,
        max = 20000,
        value = 10000,step =0.25
      )
      ,

      radioButtons(ns("radio_plotly_type"), label = h3("plotly type"),
                   choices =list("mod a" = 1, "mod b" = 2)
                   ,selected =1
      )

    )
  )

  ,
  hr()
  ,
  fluidRow(

    column(width = 4,
           div(
             class = "plotly-full-screen",
             plotlyOutput(ns("plotly_3d")) %>% shinycssloaders::withSpinner()
           )),
    column(width = 5,
           div(
             class = "plotly-full-screen",
             plotlyOutput(ns("plotly_geo"))%>% shinycssloaders::withSpinner()
           )    ),
    column(width = 3,
           div(
             class = "plotly-full-screen",
             plotlyOutput(ns("plotly_sunburst")) %>% shinycssloaders::withSpinner()
           ))

)
)
,
hr()
,
shinydashboardPlusbox_MF(
  #shinydashboardPlus::box(
  title = h5('\u0639\u0646\u0648\u0627\u0646'
             ,class ="h1t2"
  ),
  id = ns("settings_dt"),
  closable = TRUE,
  width = 12,
  height = "2000px",
  solidHeader = FALSE,
  collapsible = TRUE
  ,sidebar = shinydashboardPlus::boxSidebar(
    id = ns("settings_dt"),
    width = 25
    ,tagList(



      sliderInput(
        ns("settings_font_size_dt"),
        "marker size(plotly):",
        min = 1,
        max = 50,
        value = 15,step =1
      )



    )
  )

  ,
  hr()
  ,
  fluidRow(
    column(width = 5,
           div(
             class = "plotly-full-screen",
             plotlyOutput(ns("plotly_bar_chart"))%>% shinycssloaders::withSpinner()
           )),
    column(width = 7,
           div(
             class = "plotly-full-screen",
             DT::dataTableOutput(ns("dt_selected")) %>% shinycssloaders::withSpinner()
           ))
    )
  )

,
fluidRow(
  column(width = 2,

         verbatimTextOutput(ns("hover"))


  ),
  column(width = 2,

         verbatimTextOutput(ns("click"))


  ),
  column(width = 2,

         verbatimTextOutput(ns("brushing"))


  ),
  column(width = 2,

         verbatimTextOutput(ns("selecting"))


  ),
  column(width = 2,

         verbatimTextOutput(ns("selected"))


  )
)



#verbatimTextOutput("hover"),
#verbatimTextOutput("click"),
#verbatimTextOutput("brushing"),
#verbatimTextOutput("selecting"),
#verbatimTextOutput("brushed"),
#verbatimTextOutput("selected")


##########################################################################################
################################  end tagList  ###########################################
##########################################################################################
  )
##########################################################################################
################################    end ui     ###########################################
 #########################################################################################
##########################################################################################
}

#' module_1_2 Server Functions
#'
#' @noRd
mod_module_1_2_server <- function(id
                                  ,notificationModule
                                  ,messageModule
                                  ,taskItemModule
                                  ,dsn_list
                                  ,splunk_ls){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
################ start module server








################ end module server
  })
}

## To be copied in the UI
# mod_module_1_2_ui("module_1_2")

## To be copied in the server
# mod_module_1_2_server("module_1_2")

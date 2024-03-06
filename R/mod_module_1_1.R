#' module_1_1 UI Function
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
#' @import glue
#' @import ggplot2
#' @import readxl
#' @import stringr
#' @import colorspace
#' @import sf
#' @import purrr




mod_module_1_1_ui <- function(id){
  ns <- NS(id)
  tagList(
##########################################################################################
################################  start tagList  ###########################################
##########################################################################################



###############################################################
############### START shinydashboardPlusbox_MF ################
###############################################################
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
  ,
  ##################################################
  # start sidebar = shinydashboardPlus::boxSidebar #
  ##################################################
  sidebar = shinydashboardPlus::boxSidebar(
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
        min = 100,
        max = 200,
        value = 100,step =10
      )


    )
  )
  ##################################################
   # end sidebar = shinydashboardPlus::boxSidebar #
  ##################################################
  ,
  hr()
  ,
  fluidRow(offset = 0, style='padding:10px;',


    column(width = 2,#offset = 1, style='padding:0px;',
        uiOutput(ns('uioutput_datasets_select'))
        ,
        uiOutput(ns('uioutput_var_x')),
        uiOutput(ns('uioutput_var_y'))



    )

    ,
    column(width = 10,#offset = 1, style='padding:0px;',


           DTOutput(ns("dtoutput_data")),
           plotlyOutput(ns("plotlyoutput_data"))



    )

  )

)

###############################################################
############### END shinydashboardPlusbox_MF ##################
###############################################################

,hr()

###############################################################
############### START shinydashboardPlusbox_MF ################
###############################################################

###############################################################
###############  END shinydashboardPlusbox_MF #################
###############################################################







##########################################################################################
################################  end tagList  ###########################################
##########################################################################################
  )
##########################################################################################
################################    end ui     ###########################################
 #########################################################################################
##########################################################################################
}

#' module_1_1 Server Functions
#'
#' @noRd
mod_module_1_1_server <- function(id
                                  ,notificationModule
                                  ,messageModule
                                  ,taskItemModule
                                  ,dsn_list,
                                  splunk_ls){
  moduleServer( id, function(input, output, session){
    ns <- session$ns


#########################################################
#########################################################
################   start module server   ################
#########################################################
#########################################################
    #print('-------------')
    ##print('-------------')
    #print('---app_sys---')
    #print(getwd())
    #print(dir.exists("inst/app/www/irn_adm_unhcr_20190514"))
    #print(file.exists("inst/app/www/irn_adm_unhcr_20190514/irn_admbnda_adm1_unhcr_20190514.shp"))
    #print(list.dirs())
    #print(app_sys())

    #########################################################
    get_datasets_name<-reactive({
      purrr::keep(ls('package:datasets'),~is.data.frame(get(.x,'package:datasets')))
    })
    #########################################################


    #########################################################
    get_data<-eventReactive(input$selectInput_datasets_select,{
      get(input$selectInput_datasets_select,"package:datasets")
    })
    #########################################################


    #########################################################
    get_data_head<-eventReactive(input$selectInput_datasets_select,{
      get(input$selectInput_datasets_select,"package:datasets") %>% head()
    })
    #########################################################

    #########################################################
    output$uioutput_datasets_select<-renderUI({

      selectInput(ns("selectInput_datasets_select"),
                  "\u0645\u062c\u0645\u0648\u0639\u0647 \u062f\u0627\u062f\u0647",
                  choices = get_datasets_name()%||% NULL,
                  selected = get_datasets_name()[1]%||% NULL
                  )

    })
    #########################################################



    #########################################################
    output$uioutput_var_x<-renderUI({

      selectInput(ns("var_x"),
                  "\u0645\u062a\u063a\u06cc\u0631 \u0627\u0641\u0642\u06cc",
                  choices =names(get_data_head()) ,
                  selected = names(get_data_head())[1] %||% NULL
      )

    })
    #########################################################


    #########################################################
    output$uioutput_var_y<-renderUI({

      selectInput(ns("var_y"),
                  "\u0645\u062a\u063a\u06cc\u0631 \u0627\u0641\u0642\u06cc",
                  choices =names(get_data_head()) ,
                  selected = names(get_data_head())[2] %||% NULL
      )

    })
    #########################################################


    #########################################################
    output$plotlyoutput_data<-renderPlotly({



    })
    #########################################################



    #########################################################
    output$dtoutput_data<-renderDT({

      data_f11<-get_data()
      data_f11<- data_f11 %>% mutate(across(!where(is.numeric), as.factor))
      datatable(
        data_f11
        ,
        filter = 'top',
        extensions = c('Select', 'Buttons'),
        selection = 'none',
        options = list(select = list(style = 'os',
                                     items = 'row'),
                       dom = 'Bfrtip',
                       pageLength = 5,
                       autoWidth = TRUE,
                       buttons = list('copy' ,
                                      list(extend = 'collection',
                                           buttons = c('csv', 'excel'),
                                           text = 'Download')))

      )

    },    server = FALSE
    )
    #########################################################


#########################################################
#########################################################
################   end module server   ##################
#########################################################
#########################################################

  })
}

## To be copied in the UI
# mod_module_1_1_ui("module_1_1")

## To be copied in the server
# mod_module_1_1_server("module_1_1")

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




mod_module_1_1_ui <- function(id){
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
        value = 6,step =0.25
      )


    )
  )

  ,
  hr()
  ,
  fluidRow(
    column(width = 12,
           div(
             class = "plotly-full-screen",
           plotlyOutput(ns("plotly_iran"))%>% shinycssloaders::withSpinner()
          # plotOutput(ns("plot_iran"))%>% shinycssloaders::withSpinner()
           )


    )
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
    column(width = 12,

             DT::dataTableOutput(ns("dt_selected")) %>% shinycssloaders::withSpinner()



    )
  )

)
,
fluidRow(
  column(width = 6,

         verbatimTextOutput(ns("hover"))


  )
)
,fluidRow(
  column(width = 6,

         verbatimTextOutput(ns("click"))


  )
  # ,
  # column(width = 2,
  #
  #        verbatimTextOutput(ns("brushing"))
  #
  #
  # ),
  # column(width = 2,
  #
  #        verbatimTextOutput(ns("selecting"))
  #
  #
  # ),
  # column(width = 2,
  #
  #        verbatimTextOutput(ns("selected"))
  #
  #
  # )
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
################ start module server
    #print('-------------')
    ##print('-------------')
    #print('---app_sys---')
    #print(getwd())
    #print(dir.exists("inst/app/www/irn_adm_unhcr_20190514"))
    #print(file.exists("inst/app/www/irn_adm_unhcr_20190514/irn_admbnda_adm1_unhcr_20190514.shp"))
    #print(list.dirs())
    #print(app_sys())

    get_data<-reactive({
     # iran <-
     #   "C:\\Masoud\\statistical learning\\spatial data\\codes\\irn_adm_unhcr_20190514\\irn_admbnda_adm1_unhcr_20190514.shp"
      iran <- source_global$iran_shape_file


      #file.choose()
      iran<-st_read(iran)

      seal_coords <- do.call(rbind, st_centroid(iran)$geometry) %>%
        as_tibble() %>% setNames(c("lon","lat"))
      iran$lon <- seal_coords$lon
      iran$lat <- seal_coords$lat
      dat <-data.frame(
        id = 1:31,
        state = iran$ADM1_EN ,
        pr = c(530,-42,1673,75,206,544,1490,118,75,
               40,105,191,111,810, 609,425,418,550, 40, 425, -54,-50,
               16, 18, 133,425, -30, 241,63, 191,100))
      dat<-dat %>% mutate(color_province = case_when(pr <= 50 ~ 'green',
                                                     pr > 150 ~ 'red',
                                                     TRUE ~ 'yellow'))

      iran['color_province'] <- dat$color_province
      iran$id = 1:31
      iran


    })

    # output$plot_iran <- renderPlot({
    #   l_data <- get_data()
    #
    #   gg1 <- ggplot(l_data$iran) +
    #     geom_sf(aes(fill = ADM1_FA)) +
    #     geom_text(data = l_data$dat, aes(x = x, y = y, label = state),size=5) +
    #     theme_void()
    #   gg1
    #
    # })

    output$plotly_iran <- renderPlotly({
      l_data <- get_data()

      # gg1 <- ggplot(l_data) +
      #   geom_sf(aes(fill = color_province)) +
      #   geom_text(data = l_data, aes(x = lon, y = lat, label = ADM1_FA),size=5) +
      #   theme_void()
      # ggplotly(gg1 , tooltip = "text",source = "plotly_iran"
      #          , customdata = l_data$ADM1_FA
      #          ) %>%
      #   style(hoverlabel = list(bgcolor = "white"))
      p<-l_data %>%

        plot_ly( split = ~ADM1_FA,  color = ~color_province, name =~ADM1_FA
                 ,source = "plotly_iran"
                 #, customdata = ~ADM1_FA
                 , key=~ADM1_EN
                 )      %>%
        add_annotations(x = ~lon      ,
                        y = ~lat,
                        text = ~ADM1_FA,
                        showarrow = FALSE,
                        font = list(size = 17),
                        ax = 20,
                        ay = -20)

      p %>%
        layout(dragmode = "select") %>%
        event_register("plotly_selecting")





    })














    output$hover <- renderPrint({
      d <- event_data("plotly_hover",source="plotly_iran")
      if (is.null(d)){"Hover events appear here (unhover to clear)"
      }else{
        get_data()%>%
              data.frame() %>%
                dplyr::select(ADM1_EN) %>%
                 dplyr::filter(ADM1_EN %in%  d$key)
        #       dplyr::filter(id %in%  d$customdata)
        #       message(paste0("d$customdata:" ,d$customdata))
        }
    })
    # output$click <- renderPrint({
    #   d <- event_data("plotly_click",source="plotly_iran")
    #   if (is.null(d)) {"Click events appear here (double-click to clear)"
    #     }else{ get_data()%>%
    #     data.frame() %>%
    #     dplyr::filter(id %in%  d$customdata)
    #     message(paste0("d$customdata:" ,d$customdata))
    #     }
    #
    # })

    output$click <- renderPrint({
      d <- event_data("plotly_click",source="plotly_iran")
      if (is.null(d)) {"Click events appear here (double-click to clear)"
        }else{
        # get_data()%>%
        # data.frame() %>%
        # dplyr::filter(id %in%  d$customdata)
        message(paste0("d$customdata:" ,d$key))
        message(paste0("d:" ,names(d)))
        message(paste0("d$curveNumber:" ,d$curveNumber))
        d$key
        }

    })



    # output$brushing <- renderPrint({
    #   d <- event_data("plotly_brushing",source="plotly_iran")
    #   if (is.null(d)) "Brush extents appear here (double-click to clear)" else d
    # })
    # output$selecting <- renderPrint({
    #   d <- event_data("plotly_selecting",source="plotly_iran")
    #   if (is.null(d)) "Brush points appear here (double-click to clear)" else d
    # })
    # output$brushed <- renderPrint({
    #   d <- event_data("plotly_brushed",source="plotly_iran")
    #   if (is.null(d)) "Brush extents appear here (double-click to clear)" else d
    # })
    # output$selected <- renderPrint({
    #   d <- event_data("plotly_selected",source="plotly_iran")
    #   if (is.null(d)) "Brushed points appear here (double-click to clear)" else d
    # })





################ end module server
  })
}

## To be copied in the UI
# mod_module_1_1_ui("module_1_1")

## To be copied in the server
# mod_module_1_1_server("module_1_1")

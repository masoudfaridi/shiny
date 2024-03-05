#' module_10_2 UI Function
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

mod_module_10_2_ui <- function(id){
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

#' module_10_2 Server Functions
#'
#' @noRd
mod_module_10_2_server <- function(id
                                  ,notificationModule
                                  ,messageModule
                                  ,taskItemModule
                                  ,dsn_list
                                  ,splunk_ls){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
################ start module server

   get_data<-reactive({
     #splunk_r<-splunk_get_result_inputlookup(search_command=splunk_ls$index_acc_test4,splunk_ls=splunk_ls)

     #message("search_command:")
     #message(search_command)
     #result_connection<-splunk_check_connection()
     #if(is.na(splunk_r[1])){
       #variables_to_p<-NA
     #   return(NA)

     #}else if(!is.na(splunk_r[1]) &
     #          splunk_get_result_code(splunk_r)$Status.Message =="OK"){
     #   httr::stop_for_status(splunk_r)
     #   data_f1<-httr::content(splunk_r)
     #}
     data_f1 <- data_acc_test3
     data_f1


   })

    get_data_plotly<-reactive({
      if(input$radio_plotly_type==1){
        return(get_data())
      }else{
        #selected <- input$dt_selected_rows_selected
        #message("\n ---",selected,"---\n")
        #return(get_data()[selected, ])
        return(get_data()[input$dt_selected_rows_all,])
      }
    })



    get_data_dt_selected<-reactive({
      if(input$radio_plotly_type==1){
        d <- event_data("plotly_selected", source = "plotly_geo")
        if (is.null(d)) {data_2<-get_data()
        }else{data_2<-get_data()%>%
          dplyr::filter(ID %in%  d$customdata)
        }
        return(data_2)
      }else{

        return(get_data())
      }

    })

    get_data_for_others<-reactive({
      if(input$radio_plotly_type==1){
        d <- event_data("plotly_selected", source = "plotly_geo")
        if (is.null(d)) {data_2<-get_data()
        }else{data_2<-get_data()%>%
          dplyr::filter(ID %in%  d$customdata)
        }
        return(data_2)
      }else{

        return(get_data()[input$dt_selected_rows_all,])
      }

    })


    output$plotly_geo <- renderPlotly({
      all_colors<-c("green","red","blue")
      p<-plot_ly(data=get_data_plotly()#get_data()
                 ,
                 lat = ~x_cord,
                 lon = ~y_cord,
                 #color = ~NOE_TASADOF ,
                 color = ~type_FID ,
                 mode   = 'markers',
                 #colors=c("green","red","blue"),
                 colors=~all_colors[seq_along(unique(type_FID))],
                 marker = list(size=input$settings_marker_size),
                 type = 'scattermapbox',
                 customdata = ~ ID,
                 source = "plotly_geo"
      ) %>%
        layout(
          mapbox = list(
            style = 'open-street-map',
            zoom =10
            ,center = list(lon = 51.31, lat = 35.75)
          )
        ) %>%
        layout(legend = list(orientation = "h",   # show entries horizontally
                             xanchor = "center",  # use center of legend as anchor
                             x = 0.5))  %>%
        highlight("plotly_selected", dynamic = F,color = NULL)



      p<-p %>%
        layout(dragmode = "select") %>%
        event_register("plotly_selecting")
      p
    })

    output$dt_selected<-renderDT({

      data_f11<-get_data_dt_selected()
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
                                           buttons = c('csv', 'excel', 'pdf', 'print'),
                                           text = 'Download')))

        )

    },    server = FALSE
    )

    output$plotly_sunburst<-renderPlotly({
      list_of_sunburst_variables<-c("type_FID","type_collision","cars_type")
      DF<-get_data_for_others()
      DF<-DF %>% dplyr::select(starts_with(list_of_sunburst_variables)) %>%
        dplyr::mutate(value_column=1)
      sunburstDF <- as.sunburstDF(DF, value_column = "value_column", add_root = TRUE)

      plot_ly(data = sunburstDF, ids = ~ids, labels= ~labels,
              parents = ~parents, values= ~values, type='sunburst', branchvalues = 'total')
    })
    output$plotly_3d<-renderPlotly({
      all_colors<-c("green","red","blue")
      list_of_sunburst_variables<-c("type_FID","type_collision","cars_type")
      DF<-get_data_for_others()
      DF %>% plot_ly(x = ~type_FID, y = ~cars_type, z = ~type_collision, type="scatter3d", mode = 'markers',
                     color = ~type_FID,colors=~all_colors[seq_along(unique(type_FID))]
      ) %>%
        layout(legend = list(orientation = "h",   # show entries horizontally
                             xanchor = "center",  # use center of legend as anchor
                             x = 0.5))
    })

    output$plotly_bar_chart<-renderPlotly({
      all_colors<-c("green","red","blue")
      list_of_sunburst_variables<-c("type_FID","type_collision","cars_type")
      DF<-get_data_for_others()
      DF %>%
        dplyr::mutate(n_c=1) %>%

        plot_ly( x = ~cars_type, y =~n_c,color = ~type_FID,
                 colors=~all_colors[seq_along(unique(type_FID))],type = 'bar') %>%
        layout(yaxis = list(title = 'Count'),xaxis = list(title = ''), barmode = 'stack')%>%
        layout(legend = list(orientation = "h",   # show entries horizontally
                             xanchor = "center",  # use center of legend as anchor
                             x = 0.5))
    })






    output$hover <- renderPrint({
      d <- event_data("plotly_hover", source = "plotly_geo")
      if (is.null(d)) "Hover events appear here (unhover to clear)" else d
    })
    output$click <- renderPrint({
      d <- event_data("plotly_click", source = "plotly_geo")
      if (is.null(d)) "Click events appear here (double-click to clear)" else get_data()%>%
        dplyr::filter(ID %in%  d$customdata)
    })
    output$brushing <- renderPrint({
      d <- event_data("plotly_brushing", source = "plotly_geo")
      if (is.null(d)) "Brush extents appear here (double-click to clear)" else d
    })
    output$selecting <- renderPrint({
      d <- event_data("plotly_selecting", source = "plotly_geo")
      if (is.null(d)) "Brush points appear here (double-click to clear)" else d
    })
    output$brushed <- renderPrint({
      d <- event_data("plotly_brushed")
      if (is.null(d)) "Brush extents appear here (double-click to clear)" else d
    })
    output$selected <- renderPrint({
      d <- event_data("plotly_selected", source = "plotly_geo")
      if (is.null(d)) "Brushed points appear here (double-click to clear)" else d
    })




    #observeEvent(input$settings_plot_gis_height, {
    #  shinydashboardPlus::updateBox(
    #    "settings_shinydashboardPlusbox_MF1",
    #    action = "update",
    #    options = list(
    #      height = "4000px"
    #    )
    #  )
    #})

################ end module server
  })
}

## To be copied in the UI
# mod_module_10_2_ui("module_10_2")

## To be copied in the server
# mod_module_10_2_server("module_10_2")

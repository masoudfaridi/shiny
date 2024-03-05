#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#'
#' @import shinydashboard
#'
#' @import shinydashboardPlus
#'
#' @import dplyr
#'
#' @import shinycssloaders
#'
#' @noRd
#'
#'
app_ui <- function(request) {
  app_sys()

  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    ############################
    tags$style(
      '
        .plot-zoom {
            position: absolute;
            border: none;
            background-color: transparent;
            bottom: 0;
            right: 0;

        }
        .full-screen {
            position: fixed;
            height: 98vh !important;
            width: 98vw !important;
            left: 0;
            top: 0;
            z-index: 9999;
            overflow: hidden;
        }
        '
    )
    ,
    tags$script(HTML(
      "
        function plotZoom(el){
            el = $(el);
            var parent = el.parent().parent();
            if(el.attr('data-full_screen') === 'false') {
                parent.addClass('full-screen').trigger('resize').fadeOut().fadeIn();
                el.attr('data-full_screen', 'true');
            } else {
                parent.removeClass('full-screen').trigger('resize').fadeOut().fadeIn();
                el.attr('data-full_screen', 'false');
            }
        }

        $(function(){
           $('.plotly-full-screen  .plotly.html-widget').append(
            `
            <div style='position: relative;'>
                <button onclick=plotZoom(this) class='plot-zoom' data-full_screen='false' title='Full screen'>
                    <i class='fa fa-expand-arrows-alt'></i>
                </button>
            </div>
            `);
        })
        "
    )),
    shinydashboard::dashboardPage(

      header=
        ########################################################
      ########################################################
      shinydashboard::dashboardHeader(
        #title =
        title = h1(
          ""
          # '\u0633\u0627\u0645\u0627\u0646\u0647 \u0647\u0648\u0634\u0645\u0646\u062f \u0633\u0627\u0639\u062f'
          #,class ="h1t"
        )
        # title = h1('\u0633\u0627\u0645\u0627\u0646\u0647 \u0647\u0648\u0634\u0645\u0646\u062f \u0633\u0627\u0639\u062f',
        #align="center", style="font-family: 'B Nazanin';font-size:5px;
        #               font-weight: normal;
        #               font-thickness: 100%;
        #               font-size: 100%;
        #               ")



        ,
        #htmltools::
        tags$li(class = "dropdown",
                #       htmltools::
                tags$a(href=source_global$cybersec_ir#"https://www.cybersec.ir/"
                       , target="_blank",
                       style="
                               padding-bottom: 0px;
                               padding-top: 0px;
                          ",  #reza: change style
                       #htmltools::
                       tags$img(height = "45px", alt="cybersec", src=
                                  #app_sys(
                                  source_global$icon_1_fanavaran_2
                                  #"www/icon_1_fanavaran_2.png"
                                #)
                                #"D:/Projects/golembase/inst/app/www/icon_1_fanavaran_2.png"
                                #UI_global_menu_src1
                       )          )
        ),
        #htmltools::
        tags$li(class = "dropdown",
                #htmltools::
                tags$a(href="https://rahvar120.ir/", target="_blank", style="
                               padding-bottom: 0px;
                               padding-top: 0px;
                          ", #reza: change style
                       #                  htmltools::
                       tags$img(height = "45px", alt="cybersec", src=  #app_sys(
                                  source_global$icon_2_police.png
                                #"www/icon_2_police.png"
                                )
                       #)
                )
        )


        ,notificationUI('notificationUI')
        ,messageUI('messageUI')
        ,taskItemUI('taskItemUI')

      )


      ########################################################
      ########################################################
      ,

      sidebar=
        ########################################################
      ########################################################
      shinydashboard::dashboardSidebar(
        #id='dashboardSidebar',
        #collapsed = FALSE,
        # div(htmlOutput("welcome"), style = "padding: 20px"),
        sidebarMenu(
          # menuItem database 1
          menuItem(ui_global_variable$mI_1_0$name ,icon = icon("search"),

                   menuSubItem(ui_global_variable$mI_1_1$name, tabName = ui_global_variable$mI_1_1$ID, icon = icon("fa-sharp fa-solid fa-file-csv"))
                   ,menuSubItem(ui_global_variable$mI_1_2$name, tabName = ui_global_variable$mI_1_2$ID, icon = icon("fa-sharp fa-solid fa-file-csv"))
                   ,menuSubItem(ui_global_variable$mI_1_3$name, tabName = ui_global_variable$mI_1_3$ID, icon = icon("fa-sharp fa-solid fa-file-csv"))


          )
          ,
          menuItem(ui_global_variable$mI_2_0$name ,icon = icon("search"),

                   menuSubItem(ui_global_variable$mI_2_1$name, tabName = ui_global_variable$mI_2_1$ID, icon = icon("fa-sharp fa-solid fa-file-csv"))
                   #,menuSubItem(ui_global_variable$mI_2_2$name, tabName = ui_global_variable$mI_2_2$ID, icon = icon("fa-sharp fa-solid fa-file-csv"))
                   #,menuSubItem(ui_global_variable$mI_2_3$name, tabName = ui_global_variable$mI_2_3$ID, icon = icon("fa-sharp fa-solid fa-file-csv"))


          )




        )



      )


      ########################################################
      ########################################################
      ,

      body=
        ########################################################
      ########################################################
      shinydashboard::dashboardBody(
        tags$head(
          tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "www/c_AdminLTE.min.css")),
          tags$link(rel = "stylesheet", type = "text/css", href = "www/custom.css"),
          tags$script(inactivity)

        ),


        tabItems(
          ###  tab 1
           tabItem(tabName = ui_global_variable$mI_1_1$ID, mod_module_1_1_ui("module_1_1"))
          ,
          tabItem(tabName = ui_global_variable$mI_1_2$ID, mod_module_1_2_ui("module_1_2"))
          #,
          #tabItem(tabName = ui_global_variable$mI_1_3$ID, mod_module_1_3_ui("module_1_3"))


          ###  tab 2
          #,tabItem(tabName = ui_global_variable$mI_2_1$ID, mod_module_2_1_ui("module_2_1"))

          #,tabItem(tabName = ui_global_variable$mI_2_2$ID, mod_module_2_2_ui("module_2_2"))
          #,tabItem(tabName = ui_global_variable$mI_2_3$ID, mod_module_2_3_ui("module_2_3"))
          #,tabItem(tabName = ui_global_variable$mI_3_1$ID, mod_module_3_1_ui("module_3_1"))
          #,tabItem(tabName = ui_global_variable$mI_3_2$ID, mod_module_3_2_ui("module_3_2"))
          #,tabItem(tabName = ui_global_variable$mI_3_3$ID, mod_module_3_3_ui("module_3_3"))
          #,tabItem(tabName = ui_global_variable$mI_3_1_accuracy$ID, mod_module_3_1_accuracy_ui("module_3_1_accuracy"))
          #,tabItem(tabName = ui_global_variable$mI_3_2_accuracy$ID, mod_module_3_2_accuracy_ui("module_3_2_accuracy"))
          ## END tabItems
        )
        ## END tabItems

      )
      # END dashboardBody

      ########################################################
      ########################################################
    )

    ############################


  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "NajiVTDA"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

###################################################################
class_convert<-function(fn){

  inner <- function(...){
    return(fn(class='shinydashboardPlusbox',...))
  }
  return(inner)

}
shinydashboardPlusbox_MF<-class_convert(shinydashboardPlus::box)
# class= "widgetRTL"
# class='shinydashboardPlusbox'
#shiny::tags$div(class="widgetRTL",
#         plotlyOutput("testplot", ...)

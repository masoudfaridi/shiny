#####################################
########   shinycssloaders    #######
#####################################

options(spinner.color="#0275D8", spinner.color.background="#ffffff", spinner.size=2)
options(
  spinner.color="#0275D8",
  spinner.color.background="#ffffff",
  spinner.size=2,
  spinner.type=3)
loading_shinycssloaders<-function(fn){

  inner <- function(...){
    return(
      shinycssloaders::withSpinner(
        fn(...)
      )


    )
  }
  return(inner)

}
#tableOutput_loading<-loading_shinycssloaders(tableOutput)
#plotlyOutput_loading<-loading_shinycssloaders(plotlyOutput)
#plotOutput_loading<-loading_shinycssloaders(plotOutput)
#DTOutput_loading<-loading_shinycssloaders(DTOutput)

#####################################
########   shinycssloaders    #######
#####################################

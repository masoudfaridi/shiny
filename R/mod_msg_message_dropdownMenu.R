#' msg_message_dropdownMenu UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#'
#' @import shinydashboard
#'
#'@import shinydashboardPlus
#'
messageUI = function(id) {

  ns = NS(id)

  dropdownMenuOutput(ns('messages'))
}

#' msg_message_dropdownMenu Server Functions
#'
#' @noRd
messageServer = function(input, output, session) {
  message_list = reactiveVal()
  output$messages = renderMenu({
    validate(need(message_list(), message = FALSE))
    dropdownMenu(type = 'messages', badgeStatus = 'success', .list = message_list())
  })

  return(list(
    push_message = function(message) {
      pf = parent.env(environment())
      pf$message_list(c(pf$message_list(), list(message)))
    },
    pop_message = function() {
      pf = parent.env(environment())
      pf$message_list(message_list()[-length(pf$message_list())])
    }
  ))
}


## To be copied in the UI
# messageUI('messageUI')

## To be copied in the server
# messageModule = callModule(messageServer, 'messageUI')


#observeEvent(input$send_message, {
#   messageModule$push_message(messageItem(
#    from="from admin"
#    ,message=sprintf('Tab 1: Pushed a message at %s', Sys.time())
#
#  ))
#
#})

# messageModule$pop_message()

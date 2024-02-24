#' msg_notification_dropdownMenu UI Function
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
#' @import shinydashboardPlus
notificationUI = function(id) {

  ns = NS(id)

  dropdownMenuOutput(ns('notifications'))
}

#' msg_notification_dropdownMenu Server Functions
#'
#' @noRd
notificationServer = function(input, output, session) {
  notification_list = reactiveVal()
  output$notifications = renderMenu({
    validate(need(notification_list(), message = FALSE))
    dropdownMenu(type = 'notifications', badgeStatus = 'warning', .list = notification_list())
  })

  return(list(
    push_notification = function(message) {
      pf = parent.env(environment())
      pf$notification_list(c(pf$notification_list(), list(message)))
    },
    pop_notification = function() {
      pf = parent.env(environment())
      pf$notification_list(notification_list()[-length(pf$notification_list())])
    }
  ))
}

## To be copied in the UI
# notificationUI('notificationUI')

## To be copied in the server
# notificationModule = callModule(notificationServer, 'notificationUI')

#observeEvent(input$send_message, {
#  notificationModule$push_notification(notificationItem(sprintf('Tab2: Pushed a notification at %s', Sys.time())))
#})
#observeEvent(input$remove_message, {
#  notificationModule$pop_notification()
#})

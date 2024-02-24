#' msg_taskItem_dropdownMenu UI Function
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
taskItemUI = function(id) {

  ns = NS(id)

  dropdownMenuOutput(ns('taskItems'))
}

#' msg_taskItem_dropdownMenu Server Functions
#'
#' @noRd
taskItemServer = function(input, output, session) {
  taskItem_list = reactiveVal()
  output$taskItems = renderMenu({
    validate(need(taskItem_list(), message = FALSE))
    dropdownMenu(type = 'tasks', badgeStatus = 'success', .list = taskItem_list())
  })

  return(list(
    push_taskItem = function(message) {
      pf = parent.env(environment())
      pf$taskItem_list(c(pf$taskItem_list(), list(message)))
    },
    pop_taskItem = function() {
      pf = parent.env(environment())
      pf$taskItem_list(taskItem_list()[-length(pf$taskItem_list())])
    }
  ))
}

## To be copied in the UI
# taskItemUI("taskItemUI")

## To be copied in the server
#  taskItemModule = callModule(taskItemServer, 'taskItemUI')
#observeEvent(input$send_message, {
#    taskItemModule$push_taskItem(
#taskItem(value = 90, color = "green", sprintf('Tab 1: Pushed a message at %s', Sys.time()))
#)
#  })
#  observeEvent(input$remove_message, {
#    taskItemModule$pop_taskItem()
#  })

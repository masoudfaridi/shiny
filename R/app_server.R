#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
#' @import shinymanager
#' @import dplyr
app_server <- function(input, output, session) {
  # Your application server logic
  #app_sys()
  #add_resource_path(
  #  "www",
  #  app_sys("app/www")
  #)

  # call the server part
  # check_credentials returns a function to authenticate users
  res_auth <- secure_server(
    check_credentials = check_credentials(
      # db=app_sys("app/www/manager.sqlite"),
      db=app_sys(source_global$manager_sqlite),
      passphrase = "12345678"#key_get("R-shinymanager-key", "obiwankenobi")
      # passphrase = "passphrase_wihtout_keyring"
    )
  )

  # Timeout
  observeEvent(input$timeOut, {
    print(paste0("Session (", session$token, ") timed out at: ", Sys.time()))
    showModal(modalDialog(
      title = "Timeout",
      paste("Session timeout due to", input$timeOut, "inactivity -", Sys.time()),
      footer = NULL
    ))
    session$close()
  })

  #messageModule = callModule(mod_msg_message_dropdownMenu_server, 'messageUI')
  notificationModule = callModule(notificationServer, 'notificationUI')
  messageModule = callModule(messageServer, 'messageUI')
  taskItemModule = callModule(taskItemServer, 'taskItemUI')

  ###################
  ###################
  ###################
  ###################
  mod_module_1_1_server("module_1_1"
                        ,notificationModule
                        ,messageModule
                        ,taskItemModule
                        ,dsn_list,splunk_ls
  )

  ###################
  ###################
  mod_module_1_2_server("module_1_2"
                       ,notificationModule
                        ,messageModule
                        ,taskItemModule
                        ,dsn_list,splunk_ls
  )

  ###################
  ###################


}

#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
#' @import shinymanager
run_app <- function(
    onStart = NULL,
    options = list(),
    enableBookmarking = NULL,
    uiPattern = "/",
    ...
) {

  #source(app_sys("global.R"))
  #source(system.file("app/www/global.R",package = "MF"))
  source(app_sys("app/www/global.R"))

  #shinymanager::set_labels(
  #  language = "en",
  #  "Please authenticate" = "You have to login",
  #  "Username:" = "\u0646\u0627\u0645 \u06a9\u0627\u0631\u0628\u0631\u06cc\u003a",
  #  "Password:" = "\u0631\u0645\u0632 \u0639\u0628\u0648\u0631\u003a",
  #  "Login" = "\u0648\u0631\u0648\u062f"
  #)
  with_golem_options(
    app = shinyApp(
      ui = shinymanager::secure_app(app_ui,fab_position = "bottom-left",enable_admin = TRUE) ,
      server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}

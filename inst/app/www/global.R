library(dplyr)
library(shiny)
library(xts)
library(bsts)
library(stringr)
library(tidyr)
library(openxlsx)
library(shinydashboardPlus)
library(httr)
library(jalcal)
library(reticulate)
library(pryr)
library(RSQLite)
library(RPostgres)
library(DBI)
library(shinycssloaders)
library(plotly)
library(shinymanager)

# cat(stringi::stri_escape_unicode("شما مجاز به استفاده از این سامانه نیستید"))

set_labels(language = "en",
           "Please authenticate" = "\u0648\u0631\u0648\u062f \u06a9\u0627\u0631\u0628\u0631",
           "Username:" = "\u0646\u0627\u0645 \u06a9\u0627\u0631\u0628\u0631\u06cc:",
           "Password:" = "\u06a9\u0644\u0645\u0647 \u0639\u0628\u0648\u0631:",
           "Login" = "\u0648\u0631\u0648\u062f",
           "Logout" = "\u062e\u0631\u0648\u062c",
           "Username or password are incorrect" = "\u0646\u0627\u0645 \u06a9\u0627\u0631\u0628\u0631\u06cc \u06cc\u0627 \u06a9\u0644\u0645\u0647 \u0639\u0628\u0648\u0631 \u0627\u0634\u062a\u0628\u0627\u0647 \u0627\u0633\u062a",
           "Please change your password" = "\u0644\u0637\u0641\u0627 \u06a9\u0644\u0645\u0647 \u0639\u0628\u0648\u0631 \u062e\u0648\u062f \u0631\u0627 \u062a\u063a\u06cc\u06cc\u0631 \u062f\u0647\u06cc\u062f",
           "New password:" = "\u06a9\u0644\u0645\u0647 \u0639\u0628\u0648\u0631 \u062c\u062f\u06cc\u062f",
           "Confirm password:" = "\u062a\u0627\u06cc\u06cc\u062f \u06a9\u0644\u0645\u0647 \u0639\u0628\u0648\u0631",
           "Password must contain at least one number, one lowercase, one uppercase and must be at least length 6." = "\u06a9\u0644\u0645\u0647 \u0639\u0628\u0648\u0631 \u0628\u0627\u06cc\u062f \u062d\u062f\u0627\u0642\u0644 \u0634\u0627\u0645\u0644 \u06cc\u06a9 \u0639\u062f\u062f\u060c \u06cc\u06a9 \u062d\u0631\u0641 \u06a9\u0648\u0686\u06a9\u060c \u06cc\u06a9 \u062d\u0631\u0641 \u0628\u0632\u0631\u06af \u0648 \u062d\u062f\u0627\u0642\u0644 \u0628\u0647 \u0637\u0648\u0644 \u06f6 \u0628\u0627\u0634\u062f.",
           "Update new password" = "\u0628\u0631\u0648\u0632\u0631\u0633\u0627\u0646\u06cc \u06a9\u0644\u0645\u0647 \u0639\u0628\u0648\u0631 \u062c\u062f\u06cc\u062f",
           "Your account has expired" = "\u062d\u0633\u0627\u0628 \u06a9\u0627\u0631\u0628\u0631\u06cc \u0634\u0645\u0627 \u0645\u0646\u0642\u0636\u06cc \u0634\u062f\u0647 \u0627\u0633\u062a",
           "Your account is locked" = "\u062d\u0633\u0627\u0628 \u06a9\u0627\u0631\u0628\u0631\u06cc \u0634\u0645\u0627 \u0642\u0641\u0644 \u0634\u062f\u0647 \u0627\u0633\u062a",
           "New password cannot be the same as old" = "\u06a9\u0644\u0645\u0647 \u0639\u0628\u0648\u0631 \u062c\u062f\u06cc\u062f \u0646\u0645\u06cc \u062a\u0648\u0627\u0646\u062f \u0645\u0627\u0646\u0646\u062f \u06a9\u0644\u0645\u0647 \u0639\u0628\u0648\u0631 \u0642\u062f\u06cc\u0645\u06cc \u0628\u0627\u0634\u062f",
           "Password successfully updated! Please re-login" = "\u06a9\u0644\u0645\u0647 \u0639\u0628\u0648\u0631 \u0628\u0627 \u0645\u0648\u0641\u0642\u06cc\u062a \u0628\u0647 \u0631\u0648\u0632 \u0634\u062f! \u0644\u0637\u0641\u0627 \u062f\u0648\u0628\u0627\u0631\u0647 \u0648\u0627\u0631\u062f \u0633\u0627\u0645\u0627\u0646\u0647 \u0634\u0648\u06cc\u062f",
           "The two passwords are different" = "\u062f\u0648 \u06a9\u0644\u0645\u0647 \u0639\u0628\u0648\u0631 \u0645\u062a\u0641\u0627\u0648\u062a \u0647\u0633\u062a\u0646\u062f.",
           "Failed to update password" = "\u06a9\u0644\u0645\u0647 \u0639\u0628\u0648\u0631 \u0628\u0647 \u0631\u0648\u0632 \u0646\u0634\u062f",
           "Password does not respect safety requirements" = "\u06a9\u0644\u0645\u0647 \u0639\u0628\u0648\u0631 \u0627\u0644\u0632\u0627\u0645\u0627\u062a \u0627\u0645\u0646\u06cc\u062a\u06cc \u0631\u0627 \u0631\u0639\u0627\u06cc\u062a \u0646\u0645\u06cc \u06a9\u0646\u062f",
           "You are not authorized for this application" = "\u0634\u0645\u0627 \u0645\u062c\u0627\u0632 \u0628\u0647 \u0627\u0633\u062a\u0641\u0627\u062f\u0647 \u0627\u0632 \u0627\u06cc\u0646 \u0633\u0627\u0645\u0627\u0646\u0647 \u0646\u06cc\u0633\u062a\u06cc\u062f"
)

# menuItem
# menuSubItem 1
ui_global_variable<-list()
ui_global_variable$mI_1_0<-list(name=
                                  "GIS"
                                  ,ID=NULL,name_en="EDA")
ui_global_variable$mI_1_0_2<-list(name="\u062f\u06cc\u062a\u0627\u0628\u06cc\u0633",ID=NULL,name_en="Database")
ui_global_variable$mI_1_1<-
  list(name="\u0628\u062e\u0634 \u0627\u0648\u0644",
       ID="mI_1_1",name_en="forecaste monthly local")
ui_global_variable$mI_1_2<-
  list(name="\u0628\u062e\u0634 \u062f\u0648\u0645"
       ,ID="mI_1_2",name_en="forecaste monthly server")
ui_global_variable$mI_1_3<-
  list(name="\u062f\u0642\u062a \u0627\u0644\u06af\u0648\u0631\u06cc\u062a\u0645"
       ,ID="mI_1_3",name_en="forecaste monthly server accuracy")


##############################################################
ui_global_variable$mI_2_0<-
  list(name=
       #"\u067e\u06cc\u0634 \u0628\u06cc\u0646\u06cc \u0631\u0648\u0632\u0627\u0646\u0647"
         "\u062a\u0648\u0633\u0639\u0647"
       ,ID="mI_2_0",name_en="forecaste daily")
ui_global_variable$mI_2_1<-
  list(name=
        # "\u067e\u06cc\u0634 \u0628\u06cc\u0646\u06cc \u0631\u0648\u0632\u0627\u0646\u0647 \u0645\u062d\u0648\u0631"
       "\u0628\u062e\u0634 \u0627\u0648\u0644 \u062a\u0648\u0633\u0639\u0647"
       ,ID="mI_2_1",name_en="forecaste daily local")
ui_global_variable$mI_2_2<-
  list(name="\u067e\u06cc\u0634 \u0628\u06cc\u0646\u06cc \u0631\u0648\u0632\u0627\u0646\u0647 \u0028\u0628\u0631\u062e\u0637\u0029"
       ,ID="mI_2_2",name_en="forecaste daily server")
ui_global_variable$mI_2_3<-
  list(name="\u062f\u0642\u062a \u0627\u0644\u06af\u0648\u0631\u06cc\u062a\u0645"
       ,ID="mI_2_3",name_en="forecaste daily accuracy")


###################################################################
ui_global_variable$mI_3_0<-
  list(name="\u067e\u06cc\u0634 \u0628\u06cc\u0646\u06cc \u0645\u062d\u0648\u0631"
         ,ID="mI_3_0",name_en="connect to postgreSQL")

ui_global_variable$mI_3_1<-
  list(name="\u067e\u06cc\u0634 \u0628\u06cc\u0646\u06cc \u0645\u0627\u0647\u06cc\u0627\u0646\u0647 \u0627\u0644\u06af\u0648\u0631\u06cc\u062a\u0645 \u0627\u0648\u0644"

       #  "\u067e\u06cc\u0634 \u0628\u06cc\u0646\u06cc \u0645\u0627\u0647\u06cc\u0627\u0646\u0647"
       ,ID="mI_3_1",name_en="forecast_monthly")

ui_global_variable$mI_3_2<-
  list(name=
         "\u067e\u06cc\u0634 \u0628\u06cc\u0646\u06cc \u0645\u0627\u0647\u06cc\u0627\u0646\u0647 \u0627\u0644\u06af\u0648\u0631\u06cc\u062a\u0645 \u062f\u0648\u0645"
         #"\u067e\u06cc\u0634 \u0628\u06cc\u0646\u06cc \u0645\u0627\u0647\u06cc\u0627\u0646\u0647"
       ,ID="mI_3_2",name_en="forecast_monthly")

ui_global_variable$mI_3_3<-
  list(name=
         "\u067e\u06cc\u0634 \u0628\u06cc\u0646\u06cc \u0645\u0627\u0647\u06cc\u0627\u0646\u0647 \u0627\u0644\u06af\u0648\u0631\u06cc\u062a\u0645 \u0633\u0648\u0645"

       ,ID="mI_3_3",name_en="forecast_monthly")

ui_global_variable$mI_3_1_accuracy<-
  list(name="\u062f\u0642\u062a \u0627\u0644\u06af\u0648\u0631\u06cc\u062a\u0645 \u0627\u0648\u0644\u002d\u0645\u0627\u0647\u06cc\u0627\u0646\u0647"

                                         ,ID="mI_3_1_accuracy",name_en="forecast_monthly")
ui_global_variable$mI_3_2_accuracy<-
  list(name="\u062f\u0642\u062a \u0627\u0644\u06af\u0648\u0631\u06cc\u062a\u0645 \u062f\u0648\u0645\u002d \u0645\u0627\u0647\u06cc\u0627\u0646\u0647"

       ,ID="mI_3_2_accuracy",name_en="forecast_monthly")


ui_global_variable$mI_4_1<-
  list(name="\u067e\u06cc\u0634 \u0628\u06cc\u0646\u06cc \u0631\u0648\u0632\u0627\u0646\u0647"
       ,ID="mI_4_1",name_en="forecast_monthly")

ui_global_variable$mI_4_1<-
  list(name="\u067e\u06cc\u0634 \u0628\u06cc\u0646\u06cc \u0633\u0627\u0639\u062a\u06cc"
       ,ID="mI_4_2",name_en="forecast_monthly")



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




#########################################
############# timeout ###################
########################################

timeoutSeconds <- 900

inactivity <- sprintf("function idleTimer() {
var t = setTimeout(logout, %s);
window.onmousemove = resetTimer; // catches mouse movements
window.onmousedown = resetTimer; // catches mouse movements
window.onclick = resetTimer;     // catches mouse clicks
window.onscroll = resetTimer;    // catches scrolling
window.onkeypress = resetTimer;  //catches keyboard actions
function logout() {
Shiny.setInputValue('timeOut', '%ss')
}
function resetTimer() {
clearTimeout(t);
t = setTimeout(logout, %s);  // time is in milliseconds (1000 is 1 second)
}
}
idleTimer();", timeoutSeconds*1000, timeoutSeconds, timeoutSeconds*1000)

#######################################
splunk_ls<-list()
splunk_ls$splunk_server<-"https://127.0.0.1:8089"#'https://192.168.100.10:8089'
splunk_ls$username_1<-'splunk'
splunk_ls$password_1<-'password'
splunk_ls$index_acc_test<-"| inputlookup acc_test.csv"
splunk_ls$index_acc_test2<-"| inputlookup acc_test2.csv"
splunk_ls$index_acc_test3<-"| inputlookup acc_test3.csv"
splunk_ls$index_acc_test4<-"| inputlookup acc_test4.csv"
splunk_ls$index_acc_<-"| inputlookup US_Accidents_Dec21.csv"
status_code_all<-
structure(list(Code = c(100, 101, 102, 200, 201, 202, 203, 204,
                        205, 206, 207, 300, 301, 302, 303, 304, 305, 307, 308, 400, 401,
                        402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414,
                        415, 416, 417, 418, 419, 420, 422, 423, 424, 428, 429, 431, 451,
                        500, 501, 502, 503, 504, 505, 507, 511), Status.Code = c("CONTINUE",
                                                                                 "SWITCHING_PROTOCOLS", "PROCESSING", "OK", "CREATED", "ACCEPTED",
                                                                                 "NON_AUTHORITATIVE_INFORMATION", "NO_CONTENT", "RESET_CONTENT",
                                                                                 "PARTIAL_CONTENT", "MULTI_STATUS", "MULTIPLE_CHOICES", "MOVED_PERMANENTLY",
                                                                                 "MOVED_TEMPORARILY", "SEE_OTHER", "NOT_MODIFIED", "USE_PROXY",
                                                                                 "TEMPORARY_REDIRECT", "PERMANENT_REDIRECT", "BAD_REQUEST", "UNAUTHORIZED",
                                                                                 "PAYMENT_REQUIRED", "FORBIDDEN", "NOT_FOUND", "METHOD_NOT_ALLOWED",
                                                                                 "NOT_ACCEPTABLE", "PROXY_AUTHENTICATION_REQUIRED", "REQUEST_TIMEOUT",
                                                                                 "CONFLICT", "GONE", "LENGTH_REQUIRED", "PRECONDITION_FAILED",
                                                                                 "REQUEST_TOO_LONG", "REQUEST_URI_TOO_LONG", "UNSUPPORTED_MEDIA_TYPE",
                                                                                 "REQUESTED_RANGE_NOT_SATISFIABLE", "EXPECTATION_FAILED", "IM_A_TEAPOT",
                                                                                 "INSUFFICIENT_SPACE_ON_RESOURCE", "METHOD_FAILURE", "UNPROCESSABLE_ENTITY",
                                                                                 "LOCKED", "FAILED_DEPENDENCY", "PRECONDITION_REQUIRED", "TOO_MANY_REQUESTS",
                                                                                 "REQUEST_HEADER_FIELDS_TOO_LARGE", "UNAVAILABLE_FOR_LEGAL_REASONS",
                                                                                 "INTERNAL_SERVER_ERROR", "NOT_IMPLEMENTED", "BAD_GATEWAY", "SERVICE_UNAVAILABLE",
                                                                                 "GATEWAY_TIMEOUT", "HTTP_VERSION_NOT_SUPPORTED", "INSUFFICIENT_STORAGE",
                                                                                 "NETWORK_AUTHENTICATION_REQUIRED"), Status.Message = c("Continue",
                                                                                                                                        "Switching Protocols", "Processing", "OK", "Created", "Accepted",
                                                                                                                                        "Non Authoritative Information", "No Content", "Reset Content",
                                                                                                                                        "Partial Content", "Multi-Status", "Multiple Choices", "Moved Permanently",
                                                                                                                                        "Moved Temporarily", "See Other", "Not Modified", "Use Proxy",
                                                                                                                                        "Temporary Redirect", "Permanent Redirect", "Bad Request", "Unauthorized",
                                                                                                                                        "Payment Required", "Forbidden", "Not Found", "Method Not Allowed",
                                                                                                                                        "Not Acceptable", "Proxy Authentication Required", "Request Timeout",
                                                                                                                                        "Conflict", "Gone", "Length Required", "Precondition Failed",
                                                                                                                                        "Request Entity Too Large", "Request-URI Too Long", "Unsupported Media Type",
                                                                                                                                        "Requested Range Not Satisfiable", "Expectation Failed", "I'm a teapot",
                                                                                                                                        "Insufficient Space on Resource", "Method Failure", "Unprocessable Entity",
                                                                                                                                        "Locked", "Failed Dependency", "Precondition Required", "Too Many Requests",
                                                                                                                                        "Request Header Fields Too Large", "Unavailable For Legal Reasons",
                                                                                                                                        "Internal Server Error", "Not Implemented", "Bad Gateway", "Service Unavailable",
                                                                                                                                        "Gateway Timeout", "HTTP Version Not Supported", "Insufficient Storage",
                                                                                                                                        "Network Authentication Required")), row.names = c(NA, 55L), class = "data.frame")

##########################################################################
splunk_get_result <- function(search_command,splunk_ls) {
  out <- tryCatch(
    {


      message("This is the 'try' part of connection")
      r1<-httr::POST(splunk_ls$splunk_server,
                       path = "services/search/jobs",
                       httr::config( ssl_verifyhost = FALSE, ssl_verifypeer = 0),
                       httr::authenticate(splunk_ls$username_1, splunk_ls$password_1),
                       encode = "form",
                       body = list( search =search_command ,
                                    exec_mode = "oneshot",
                                    output_mode = "csv"
                                    ,count=0),
                       httr::verbose())
      httr::stop_for_status(r1)
      r1
      #result_code<-  dplyr::left_join(data.frame(Code=httr::status_code(r1)),status_code_all,by ="Code" )
      #list(r1=r1,result_code=result_code)



    },
    error=function(cond) {
      message(paste0("Error 10001: ","httrPOST, connection to splunk failed"))
      # Choose a return value in case of error
      return(NA)
    },
    finally={
      message(paste("Processed connection has finished"))

    }
  )
  return(out)
}
search_command_convert<-function(search_command){
  paste0("search ", search_command
         , collapse="", sep="")
}
splunk_get_result_inputlookup<-function(search_command,splunk_ls){

  out <- tryCatch(
    {


      message("This is the 'try' part of connection")
      r1<-httr::POST(splunk_ls$splunk_server,
                     path = "services/search/jobs",
                     httr::config( ssl_verifyhost = FALSE, ssl_verifypeer = 0),
                     httr::authenticate(splunk_ls$username_1, splunk_ls$password_1),
                     encode = "form",
                     body = list( search =search_command ,
                                  exec_mode = "oneshot",
                                  output_mode = "csv"
                                  ,count=0),
                     httr::verbose())
      httr::stop_for_status(r1)
      r1
      #result_code<-  dplyr::left_join(data.frame(Code=httr::status_code(r1)),status_code_all,by ="Code" )
      #list(r1=r1,result_code=result_code)



    },
    error=function(cond) {
      message(paste0("Error 10001: ","httrPOST, connection to splunk failed"))
      # Choose a return value in case of error
      return(NA)
    },
    finally={
      message(paste("Processed connection has finished"))

    }
  )
  return(out)
}

splunk_get_result_code<-function(r1){
  dplyr::left_join(data.frame(Code=httr::status_code(r1)),status_code_all,by ="Code" )
}

splunk_check_connection<-function(){
  splunk_r<-splunk_get_result("noop | stats count",splunk_ls)
  if(is.na(splunk_r)[1]){
  return(NA)
  }else if(!is.na(splunk_r)[1] & splunk_get_result_code(splunk_r)$Status.Message =="OK"){

      return("OK")
  }else{
    return(splunk_get_result_code(splunk_r)$Status.Message)
  }
}




get_cpu_ram_usage_Python<-function(){
  library(reticulate)
  aa<-reticulate::import("psutil")
  list(cpu_percent=aa$cpu_percent(),
       mem_percent=aa$virtual_memory()$percent)
}

get_mem_used<-function(){
  total_mem<-system("wmic ComputerSystem get TotalPhysicalMemory", intern = TRUE)
  total_mem<-as.numeric(gsub("\\D", "", total_mem[2]))
  total_mem<-total_mem/1000
  free_mem<-system("wmic OS get FreePhysicalMemory", intern = TRUE)
  free_mem<-as.numeric(gsub("\\D", "", free_mem[2]))
  used_mem<-total_mem-free_mem
  percentage_used_mem<-1-free_mem/total_mem
  R_mem_used<-floor(as.numeric(pryr::mem_used()/1000000))
  df<-list(R_mem_used=paste(R_mem_used,"MB")
                 ,gc_1=gc(verbose = TRUE)
             ,total_mem_used=total_mem
           ,free_mem=free_mem
              ,percentage_mem_used=percentage_used_mem)
  df
}

get_object_size<-function(obj){
  pryr::object_size(obj)
}
#all_year<-sort(unique(as.data.frame(get_year_month_all())$JYEAR))
#all_year_month<-as.data.frame(get_year_month_all())
#all_year_month<-dplyr::arrange(all_year_month,JYEAR,JMONTH)
###########################
# postgreSQL 14
dsn_list<-list()
dsn_list$dbname<-"mob"
dsn_list$host<-"localhost"
dsn_list$port<-"5432"
dsn_list$user<-"postgres"
dsn_list$password<-"password"
dsn_list$data_acc_test<- "acc_test"
  #"data_monthly_2023_01_17_01"
dsn_list$data_US_Accidents_Dec21<-"US_Accidents_Dec21"
command_acc_test<-
'SELECT * FROM acc_test'
postgresql_get_connection <- function(dsn_list) {
  out <- tryCatch(
    {


      message("This is the 'try' part of connection")
      #con <- dbConnect(RSQLite::SQLite(), ":memory:")
      con<-DBI::dbConnect(RPostgres::Postgres()
                     ,dbname = dsn_list$dbname,
                     host = dsn_list$host,
                     port = dsn_list$port,
                     user = dsn_list$user,
                     password = dsn_list$password
      )
      con



    },
    error=function(cond) {
      message(paste0("Error 10001: ","httrPOST, connection to PostgreSQL failed"))
      # Choose a return value in case of error
      return(NA)
    },
    finally={
      message(paste("Processed connection to postgresql has finished"))

    }
  )
  return(out)
}


#######################################################################



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

as.sunburstDF <- function(DF, value_column = NULL, add_root = FALSE){
  require(data.table)

  colNamesDF <- names(DF)

  if(is.data.table(DF)){
    DT <- copy(DF)
  } else {
    DT <- data.table(DF, stringsAsFactors = FALSE)
  }

  if(add_root){
    DT[, root := "Total"]
  }

  colNamesDT <- names(DT)
  hierarchy_columns <- setdiff(colNamesDT, value_column)
  DT[, (hierarchy_columns) := lapply(.SD, as.factor), .SDcols = hierarchy_columns]

  if(is.null(value_column) && add_root){
    setcolorder(DT, c("root", colNamesDF))
  } else if(!is.null(value_column) && !add_root) {
    setnames(DT, value_column, "values", skip_absent=TRUE)
    setcolorder(DT, c(setdiff(colNamesDF, value_column), "values"))
  } else if(!is.null(value_column) && add_root) {
    setnames(DT, value_column, "values", skip_absent=TRUE)
    setcolorder(DT, c("root", setdiff(colNamesDF, value_column), "values"))
  }

  hierarchyList <- list()

  for(i in seq_along(hierarchy_columns)){
    current_columns <- colNamesDT[1:i]
    if(is.null(value_column)){
      currentDT <- unique(DT[, ..current_columns][, values := .N, by = current_columns], by = current_columns)
    } else {
      currentDT <- DT[, lapply(.SD, sum, na.rm = TRUE), by=current_columns, .SDcols = "values"]
    }
    setnames(currentDT, length(current_columns), "labels")
    hierarchyList[[i]] <- currentDT
  }

  hierarchyDT <- rbindlist(hierarchyList, use.names = TRUE, fill = TRUE)

  parent_columns <- setdiff(names(hierarchyDT), c("labels", "values", value_column))
  hierarchyDT[, parents := apply(.SD, 1, function(x){fifelse(all(is.na(x)), yes = NA_character_, no = paste(x[!is.na(x)], sep = ":", collapse = " - "))}), .SDcols = parent_columns]
  hierarchyDT[, ids := apply(.SD, 1, function(x){paste(x[!is.na(x)], collapse = " - ")}), .SDcols = c("parents", "labels")]
  hierarchyDT[, c(parent_columns) := NULL]
  return(hierarchyDT)
}

data_acc_test3<-# read.csv("inst/app/www/acc_test3.csv")
  openxlsx::read.xlsx("inst/app/www/acc_test3.xlsx")

###########  sources


#Note
#print(app_sys())
#[1] "C:/Masoud/shinyproject/inst"


## run_app.R
#src = "www/logo_0_fanavaran.png"
source_global<-list()
source_global$logo_0_fanavaran= "www/logo_0_fanavaran.png"


## app_server.R
## db=app_sys("app/www/manager.sqlite")
source_global$manager_sqlite<-"app/www/manager.sqlite"


## app_ui.R
## tags$a(href="https://www.cybersec.ir/", target="_blank",
source_global$cybersec_ir<-"https://www.cybersec.ir/"


## mod_module_1_1.R
# "inst/app/www/rn_adm_unhcr_20190514/irn_admbnda_adm1_unhcr_20190514.shp"
source_global$iran_shape_file=
"inst/app/www/irn_adm_unhcr_20190514/irn_admbnda_adm1_unhcr_20190514.shp"


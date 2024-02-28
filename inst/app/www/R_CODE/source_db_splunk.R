

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

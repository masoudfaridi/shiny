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

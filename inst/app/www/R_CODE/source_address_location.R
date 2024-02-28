###########  sources


#Note
#print(app_sys())
#[1] "C:/Masoud/shinyproject/inst"


## run_app.R
#src = "www/logo_0_fanavaran.png"
source_global<-list()
source_global$logo_0_fanavaran= "www/images/logo_0_fanavaran.png"


## app_server.R
## db=app_sys("app/www/manager.sqlite")
source_global$manager_sqlite<-"app/www/db/manager.sqlite"


## app_ui.R
## tags$a(href="https://www.cybersec.ir/", target="_blank",
source_global$cybersec_ir<-"https://www.cybersec.ir/"


## mod_module_1_1.R
# "inst/app/www/rn_adm_unhcr_20190514/irn_admbnda_adm1_unhcr_20190514.shp"
source_global$iran_shape_file=
  "inst/app/www/irn_adm_unhcr_20190514/irn_admbnda_adm1_unhcr_20190514.shp"


##
source_global$data_acc_test3="inst/app/www/files/acc_test3.xlsx"


## app_ui.R

source_global$icon_1_fanavaran_2<-"inst/app/www/images/icon_1_fanavaran_2.png"

source_global$icon_1_fanavaran_2<-"inst/app/www/images/icon_1_fanavaran_2.png"
source_global$icon_1_fanavaran_2<-"inst/app/www/images/icon_1_fanavaran_2.png"

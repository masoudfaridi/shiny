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





## mod_module_1_1.R
# "inst/app/www/rn_adm_unhcr_20190514/irn_admbnda_adm1_unhcr_20190514.shp"
source_global$iran_shape_file=
  "inst/app/www/files/shape_files/irn_adm_unhcr_20190514/irn_admbnda_adm1_unhcr_20190514.shp"


## source_loading_excel_files.R
source_global$data_acc_test3="inst/app/www/files/excel_files/acc_test3.xlsx"



#######################################################
####################### app_ui.R  #####################
#######################################################

## app_ui.R
## tags$a(href="https://www.cybersec.ir/", target="_blank",
source_global$cybersec_ir<-"https://www.cybersec.ir/"

## app_ui.R
#### reference by www/...
source_global$icon_1_fanavaran_2<-"www/images/icon_1_fanavaran_2.png"
  #"inst/app/www/images/icon_1_fanavaran_2.png"
## app_ui.R
#### reference by www/...
source_global$icon_2_police<-"www/images/icon_2_police.png"
  #"inst/app/www/images/icon_2_police.png"
## app_ui.R
#### reference by www/...
source_global$css_c_AdminLTE_min_css <-"www/c_AdminLTE.min.css"

## app_ui.R
#### reference by www/...
source_global$css_custom_css <-"www/custom.css"


#######################################################
####################### End app_ui.R  #################
#######################################################

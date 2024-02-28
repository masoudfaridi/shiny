
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



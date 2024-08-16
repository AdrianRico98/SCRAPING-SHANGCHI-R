#1. Cargo las librerias que vamos a utilizar.
library(rvest)
library(stringr)
library(tidyverse)
library(openxlsx)

#2. #Leo el código html de la página, extraigo las distintas tablas y las convierto en dataframes. 
link <- "https://www.boxofficemojo.com/title/tt9376612/?ref_=bo_se_r_1"
page <- read_html(link)
tables <- page %>% html_nodes("table")
table <- tables[[1]] %>% html_table() #extraemos la primera tabla.
##Ya que debo extraer las cuatro tablas, hago un bucle que las cree y las agrupe en una lista
tables_list <- list()

for (i in 1:length(tables)){
  table <- tables[[i]] %>% html_table()
  tables_list[[i]] <- table
}

assign("mercado_domestico", tables_list[[1]])
assign("europa_africa", tables_list[[2]])
assign("america_latina", tables_list[[3]])
assign("asia_pacific", tables_list[[4]])


#3. Procedo a limpiar las tablas y crear la tabla final.
##Todas las tablas presentan el mismo formato y los cambios que debo hacer son:
### 3.1 Añadir una variable denominada "region" donde se muestre la región de cada país o mercado en todas las tablas.
preprocesamiento <- function(data){
  #nombre del dataframe
  nombre <- deparse(substitute(data))
  #procesado
  data <- data %>%
    mutate(Region = rep(nombre, each= nrow(data))) %>%
    select(Region,Area,`Release Date`,Opening,Gross)
}

america_latina <- preprocesamiento(america_latina)
mercado_domestico <- preprocesamiento(mercado_domestico)
europa_africa <- preprocesamiento(europa_africa)
asia_pacific <- preprocesamiento(asia_pacific)

### 3.2 Formatear la fecha correctamente con lubridate.
america_latina <- america_latina %>% mutate(`Release Date`= america_latina$`Release Date` %>% mdy())
asia_pacific <- asia_pacific %>% mutate(`Release Date` = asia_pacific$`Release Date`%>% mdy())
europa_africa <- europa_africa %>% mutate(`Release Date` = europa_africa$`Release Date` %>% mdy())
mercado_domestico <- mercado_domestico %>% mutate(`Release Date` = mercado_domestico$`Release Date` %>% mdy())
### 3.3 Elimino el dólar con la expresión regular y formateo los números para que puedan ser utilizados por el programa.
patron <- "^\\$"
america_latina <- america_latina %>% mutate(Opening = america_latina$Opening %>% str_remove_all(patron) %>% parse_number(),
                                            Gross = america_latina$Gross %>% str_remove_all(patron) %>% parse_number())

asia_pacific <- asia_pacific %>% mutate(Opening = asia_pacific$Opening %>% str_remove_all(patron) %>% parse_number(),
                                            Gross = asia_pacific$Gross %>% str_remove_all(patron) %>% parse_number())                     

europa_africa <- europa_africa %>% mutate(Opening = europa_africa$Opening %>% str_remove_all(patron) %>% parse_number(),
                                        Gross = europa_africa$Gross %>% str_remove_all(patron) %>% parse_number())   

mercado_domestico <- mercado_domestico %>% mutate(Opening = mercado_domestico$Opening %>% str_remove_all(patron) %>% parse_number(),
                                         Gross = mercado_domestico$Gross %>% str_remove_all(patron) %>% parse_number())   


### Pongo unos nombres mas "amigables" y realizo la union de las tablas.
nombres <- c("Region", "Mercado", "Fecha de Estreno", "Ingresos Estreno", "Ingresos Totales")
america_latina <- america_latina %>% set_names(nombres)
asia_pacific <- asia_pacific %>% set_names(nombres)
europa_africa <- europa_africa %>% set_names(nombres)
mercado_domestico <- mercado_domestico %>% set_names(nombres)
shang_chi <- union(america_latina,asia_pacific) %>% union(europa_africa) %>% union(mercado_domestico)

#4. Exporto la tabla final a un excel que se va ejecutando periódicamente gracias al programador de tareas de windows.
write.xlsx(shang_chi,"shang_chi.xlsx", asTable = TRUE, overwrite = TRUE) 



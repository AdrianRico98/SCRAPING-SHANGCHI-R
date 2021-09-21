#1. Cargolas librerias que vamos a utilizar.
library(rvest)
library(stringr)
library(tidyverse)
library(openxlsx)

#2. #Leo el c�digo html de la p�gina, extraigo las distintas tablas y las convierto en dataframes. 
link <- "https://www.boxofficemojo.com/title/tt9376612/?ref_=bo_se_r_1"
page <- read_html(link)
tables <- page %>% html_nodes("table")
table <- tables[[1]] %>% html_table() #extraemos la primera tabla.
##Ya que debo extraer las cuatro tablas, creo una funci�n que haga mas eficiente el proceso de extracci�n. LLamo a la funci�n "scraping".
scraping <- function(n){
  link <- "https://www.boxofficemojo.com/title/tt9376612/?ref_=bo_se_r_1"
  page <- read_html(link)
  tables <- page %>% html_nodes("table")
  table <- tables[[n]] %>% html_table()
  table
}
mercado_domestico <- scraping(1) #generola tabla con el mercado dom�stico.
europa_africa <- scraping(2) #genero la tabla con el mercado europeo y africano.
america_latina <- scraping(3) #genero la tabla con el mercado latinoamericano.
asia_pacific <- scraping(4) #genero la tabla con el mercado asiatico y del pac�fico.

#3. Procedo a limpiar las tablas y crear la tabla final.
##Todas las tablas presentan el mismo formato y los cambios que debo hacer son:
### 3.1 A�adir una variable denominada "region" donde se muestre la regi�n de cada pa�s o mercado en todas las tablas.
america_latina <- america_latina %>% 
  mutate(Region = rep("America Latina", each= nrow(america_latina))) %>%
  select(Region,Area,`Release Date`,Opening,Gross)

asia_pacific <- asia_pacific %>%
  mutate(Region = rep("Asia Pacific", each= nrow(asia_pacific))) %>%
  select(Region,Area,`Release Date`,Opening,Gross)


europa_africa <- europa_africa %>%
  mutate(Region = rep("Europa/Africa", each= nrow(europa_africa))) %>%
  select(Region,Area,`Release Date`,Opening,Gross)

mercado_domestico <- mercado_domestico %>%
  mutate(Region = rep("Mercado domestico", each= nrow(mercado_domestico))) %>%
  select(Region,Area,`Release Date`,Opening,Gross)
### 3.2 Formatear la fecha correctamente con lubridate.
america_latina <- america_latina %>% mutate(`Release Date`= america_latina$`Release Date` %>% mdy())
asia_pacific <- asia_pacific %>% mutate(`Release Date` = asia_pacific$`Release Date`%>% mdy())
europa_africa <- europa_africa %>% mutate(`Release Date` = europa_africa$`Release Date` %>% mdy())
mercado_domestico <- mercado_domestico %>% mutate(`Release Date` = mercado_domestico$`Release Date` %>% mdy())
### 3.3 Elimino el d�lar con la expresi�n regular y formateo los n�meros para que puedan ser utilizados por el programa.
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

#4. Exporto la tabla final a un excel que se va ejecutando peri�dicamente gracias al programador de tareas de windows.
write.xlsx(shang_chi,"shang_chi.xlsx", asTable = TRUE, overwrite = TRUE) 


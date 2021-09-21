#1 .En cualquier momento queinterese, importamos los datos actualizados en el mismo día
library(readxl)
shang_chi <- read_excel("shang_chi.xlsx") #es recomendable cambiar el working directory a donde se encuentra el proyecto para no escribir rutas completas

#2. De forma superficial, puesto que el objetivo principal del proyecto ya esta logrado, voy a explorar los datos con dos preguntas:
library(tidyverse)
library(ggrepel)
library(ggthemes)
#2.1 ¿En qué región esta consiguiendo mas ingresos la película? ¿y menos? ¿ Cómo se estan comportando, en términos de ingresos, los distintos mercados de las regiones?
shang_chi %>% 
  ggplot(aes(Region,`Ingresos Totales`, col = Region)) + 
  scale_y_continuous(trans = "log2") +
  geom_point(aes()) +
  xlab(" Regiones")+
  ylab("Ingresos Totales hasta hoy (escala logarítmica)")+
  theme(legend.position = "none") +
  ggtitle("SHANG CHI: Comparación del rendimiento de la película entre/intra regiones") +
  geom_text_repel(aes(Region, label = Mercado), nudge_y = 0.15, size = 4) +
  theme_solarized_2()
#2.2 ¿Qué peso tienen las distintas regiones en los ingresos totales?
## Los ingresos totales a nivel mundial de la película son:
ingresos_mundiales <- shang_chi %>% 
  summarize(ingresos_mundiales = sum(`Ingresos Totales`)) %>% 
  pull (ingresos_mundiales)
## calculo el peso respecto a los ingresos mundiales por region:
shang_chi %>% 
  group_by(Region) %>% 
  summarize(ingresos_por_region = sum(`Ingresos Totales`)) %>%
  mutate(ingresos_por_region_porcentaje = (ingresos_por_region/ingresos_mundiales) * 100) %>%
  select(Region,ingresos_por_region_porcentaje) %>%
  arrange(desc(ingresos_por_region_porcentaje))




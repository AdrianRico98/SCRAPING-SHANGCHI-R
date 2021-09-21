SCRAPING Y WRANGLING: SHANG CHI Y LA LEYENDA DE LOS DIEZ ANILLOS
================
Proyecto creado por Adrián Rico Alonso -
21/9/2021

## OBJETIVO DEL PROYECTO

En este proyecto trato de extraer y unificar los datos de rendimiento
mundial de la película de marvel “Shang Chi y la Leyenda de los Diez
Anillos”, la cual se encuentra actualmente en taquilla. Los datos se
encuentran en la siguiente web : [Box office mojo: Shang
Chi](https://www.boxofficemojo.com/title/tt9376612/?ref_=bo_rl_ti).

El objetivo es doble:

1: Por un lado, trato de demostrar mis conocimientos de programación en
R para la realización de web scraping y limpieza/manipulación de datos
(data wrangling).

2: Por otro lado, busco además que el código sea **reproducible
periódicamente**, de modo que, si creo una tarea programada en el
sistema operativo, se extraigan los datos actualizados cada día (o con
la que frecuencia que desee).

## ¿QUÉ PUEDES ENCONTRAR EN LOS SCRIPTS?

En el repositorio se pueden encontrar dos scripts:

### 1: Scraping\_y\_Wrangling.R.

Se encuentra el código que extrae y limpia los datos, explicado con
anotación dentro del propio script. Básicamente, ejecuto un proceso de
**tres pasos**:

1: Creo una función que me permite extraer el código html de la web, el
nodo “table” y sus cuatro elementos (las cuatro tablas que me interesa
unificar).

2: Limpio las tablas de las distintas regiones utilizando código que sea
ejecutable en cualquier momento sobre la web y unifico las tablas.

3: Guardo el resultado final en el directorio de trabajo en formato
xlsx.

Nota\*: existe una “cuarta parte” que consiste en crear en el
programador de tareas de windows la ejecución diaria del script, para
tener siempre en el directorio de trabajo la versión actualizada del
rendimiento que esta teniendo la película.

### 2: EDA.R.

Si bien el objetivo del proyecto se encuentra cumplido con el primer
script, en este script realizo un **análisis exploratorio** muy básico y
breve de los datos actualizados a 21 de septiembre de 2021.

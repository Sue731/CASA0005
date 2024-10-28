library(sf)
library(tmap)
library(tmaptools)
library(RSQLite)
library(tidyverse) 
library(here)
library(janitor)
library(stringr)
library(plotly)
library(OpenStreetMap)
library(raster)
library(terra)

#导入.csv数据
GII_data <- read_csv(here::here("prac4_data","GII_data.csv"),
                     locale=locale(encoding = "latin1"),
                     na = "n/a")
class(GII_data)

#导入空间数据
#列出gpkg文件中的所有层
st_layers(here(
  "prac4_data","World_Countries_(Generalized)_9029012925078512962.geojson"))
world_scale <- st_read(here(
  "prac4_data","World_Countries_(Generalized)_9029012925078512962.geojson"))
                  
print(world_scale)
st_crs(world_scale)$proj4string

class(world_scale)
plot(world_scale)

world_geo <- st_geometry(world_scale)
plot(world_geo)

#合并数据
combined_data <- world_scale%>%
  clean_names()%>%
  left_join(GII_data,by = "country")





  
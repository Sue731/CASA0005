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

#分开两个年份
combined_data_wide <- combined_data%>%
  drop_na(value)%>%
  pivot_wider(names_from = year,
               values_from =value, 
               names_prefix="year_")
    
#计算差值
data_difference <- combined_data_wide%>%
  mutate(difference = year_2019 - year_2010,na.rm=TRUE)

tmap_mode("plot")
data_difference %>%
  qtm(.,fill = "year_2010")

tmap_mode("plot")
data_difference %>%
  qtm(.,fill = "year_2019")


gg_2010 <- ggplot(data_difference,aes(x=year_2010))+
  geom_histogram(color="black", fill="white")+
  labs(title="global gender inequality in 2010", 
       x="value", 
       y="Frequency") 

print(gg_2010)

gg_2019 <- ggplot(data_difference,aes(x=year_2019))+
  geom_histogram(color="black", fill="white")+
  labs(title="global gender inequality in 2019", 
       x="value", 
       y="Frequency") 

print(gg_2019)

gg_difference <- ggplot(data_difference,aes(x=difference))+
  geom_histogram(color="black", fill="white")+
  labs(title="the difference of global gender inequality between 2010 and 2019", 
       x="value", 
       y="Frequency") 

print(gg_difference)  

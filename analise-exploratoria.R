library(tidyverse)
library(sf)
library(sp)
library(rgdal)
library(rgeos)
library(tmap)
library(tmaptools)
library(spgwr)
library(parallel)

# detect number of CPU cores to go parallel
no_cores <- detectCores() - 1 # Calculate the number of cores
cl <- makeCluster(no_cores)# Initiate cluster 

df <- read_csv("data/data-1598412599715-3.csv")

# Arrumar dados, tudo que é string vira factor

df <- df %>% 
  select(
    -area_arbor,-nomemunici, -numeromuni
  ) %>% 
  mutate(
    indicador_massa_arborea = as.numeric(str_replace(indicador_massa_arborea, ",", "."))
  ) %>% 
  mutate(
    numerozona = as_factor(numerozona),
    numdistrit = as_factor(numdistrit)
  ) %>% 
  mutate_if(
    is_character, as_factor
  ) %>% 
  rename(
    lat = centroid_lat,
    long = centroid_long
  )

# read in the shapefile using the sf function sf::st_read
# SHP vindo daqui: http://dados.prefeitura.sp.gov.br/dataset/zona-de-origem-e-destino-1997-e-2007-no-municipio-de-sao-paulo/resource/6cbb32f4-378f-4051-b210-506f435c29e6
distritos <- st_read("SHP/DEINFO_ZONAS_OD_2007.shp")
Encoding(distritos$NOMEZONA) <- "latin1"

# Join com o SHP
df <- df %>% 
  inner_join(distritos, by = c("id" = "ZONA")) %>% 
  st_as_sf

# Geographic Weighted Regression (GWR)
# First we will calibrate the bandwidth of the kernel that will be used to capture the points for each regression and then run the model
GWRbandwidth <- gwr.sel(indicador_massa_arborea ~ renda_per_capita + domicilios + automoveis + empregos,
                        data = df, coords = cbind(df$lat, df$long), adapt = T)

gwr.model <- gwr(indicador_massa_arborea ~ renda_per_capita + domicilios + automoveis + empregos,
                 data = df, coords = cbind (df$lat, df$long), adapt = GWRbandwidth, hatmatrix = TRUE, se.fit = TRUE)

# get spatial spatial polygon dataframe from regression results + convert it into sf object. The spatial object brings the regressions results within it's data component
results <- gwr.model$SDF
gwr.map <- cbind(df, results)

# Plot Stuff
map0 <- tm_shape(gwr.map) + 
  tm_fill("indicador_massa_arborea",
          title="Massa Arbórea",
          n = 5,
          style = "quantile") +
  tm_borders() +
  tm_layout(frame = FALSE,
            legend.text.size = 0.5,
            legend.title.size = 0.6)
tmap_save(map0, "images/massa_aborea.png", dpi = 300)

map1 <- tm_shape(gwr.map) + 
  tm_fill("localR2",
          title="R2 Local",
          n = 5,
          style = "quantile") +
  tm_borders() +
  tm_layout(frame = FALSE,
            legend.text.size = 0.5,
            legend.title.size = 0.6)
tmap_save(map1, "images/R2_local.png", dpi = 300)

map2 <- tm_shape(gwr.map) + 
  tm_fill("renda_per_capita",
          title="Renda Per Capita",
          n = 5,
          style = "quantile") +
  tm_borders() +
  tm_layout(frame = FALSE,
            legend.text.size = 0.5,
            legend.title.size = 0.6)
tmap_save(map2, "images/renda_per_cap.png", dpi = 300)

map3 <- tm_shape(gwr.map) + 
  tm_fill("domicilios",
          title="Domicílios",
          n = 5,
          style = "quantile") +
  tm_borders() +
  tm_layout(frame = FALSE,
            legend.text.size = 0.5,
            legend.title.size = 0.6)
tmap_save(map3, "images/domicilios.png", dpi = 300)

map4 <- tm_shape(gwr.map) + 
  tm_fill("automoveis",
          title="Automóveis",
          n = 5,
          style = "quantile") +
  tm_borders() +
  tm_layout(frame = FALSE,
            legend.text.size = 0.5,
            legend.title.size = 0.6)
tmap_save(map4, "images/automoveis.png", dpi = 300)

map5 <- tm_shape(gwr.map) + 
  tm_fill("empregos",
          title="Empregos",
          n = 5,
          style = "quantile") +
  tm_borders() +
  tm_layout(frame = FALSE,
            legend.text.size = 0.5,
            legend.title.size = 0.6)
tmap_save(map5, "images/empregos.png", dpi = 300)

map6 <- tm_shape(gwr.map) + 
  tm_fill("empregos",
          title="Empregos",
          n = 5,
          style = "quantile") +
  tm_borders() +
  tm_layout(frame = FALSE,
            legend.text.size = 0.5,
            legend.title.size = 0.6)
tmap_save(map6, "images/empregos.png", dpi = 300)



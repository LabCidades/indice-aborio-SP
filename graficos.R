source("analise-exploratoria.R")

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

library(spgwr)
library(GWmodel)
library(kableExtra)

tbl_regression(as_tibble(gwr.model))

tbl_regression(lm(mpg~cyl+wt, data=mtcars))

source("analise-exploratoria.R")

df.sp <- as_Spatial(df)

m <- lm(indicador_massa_arborea ~ renda_per_capita + domicilios + automoveis + empregos,
        data = df)

bw <- bw.gwr(indicador_massa_arborea ~ renda_per_capita + domicilios + automoveis + empregos,
             adaptive = T,
             data=df.sp) 

m4 <- gwr.basic(indicador_massa_arborea ~ renda_per_capita + domicilios + automoveis + empregos, 
                adaptive = T,
                data = df.sp,
                bw = bw)  

tab <- rbind(apply(m4$SDF@data[, 1:5], 2, summary), coef(m))
rownames(tab)[7] <- "Global"
#tab <- round(tab, 3)
rownames(tab) <- c("Mín", "1º Quantil", "Mediana", "Média", "3º Quantil", "Máx", "Global")
colnames(tab) <- c("Constante", "Renda per Capita", "Domicílios", "Automóveis", "Empregos")

kable(tab, booktabs = T, format = 'markdown', digits = 6)

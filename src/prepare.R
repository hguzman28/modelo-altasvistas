library(readr)
library(dplyr)

# Lee el archivo CSV con especificaciones de columna
col_types <- cols(
  id = col_double(),
  Name = col_character(),
  Marathon = col_character(),
  Category = col_character(),
  km4week = col_double(),
  sp4week = col_double(),
  CrossTraining = col_character(),
  Wall21 = col_double(),
  CATEGORY = col_character(),
  MarathonTime = col_double()
)

datos_maraton <- read_csv("./data/raw/MarathonData.csv", col_types = col_types)

datos_maraton$Wall21 <- as.numeric(datos_maraton$Wall21, errors = 'coerce')

datos_maraton <- datos_maraton %>%
  select(-c(Name, id, Marathon, CATEGORY))

datos_maraton$CrossTraining[is.na(datos_maraton$CrossTraining)] <- 0

datos_maraton <- datos_maraton %>%
  filter(!is.na(CrossTraining))

valores_cross <- c("ciclista 1h" = 1, "ciclista 3h" = 2, "ciclista 4h" = 3, "ciclista 5h" = 4, "ciclista 13h" = 5)
datos_maraton$CrossTraining <- valores_cross[datos_maraton$CrossTraining]

valores_categoria <- c("MAM" = 1, "M45" = 2, "M40" = 3, "M50" = 4, "M55" = 5, "WAM" = 6)
datos_maraton$Category <- valores_categoria[datos_maraton$Category]

datos_maraton <- datos_maraton %>%
  filter(sp4week < 1000)

write_csv(datos_maraton, "./data/processed/data_processed.csv")

library(readr)
library(dplyr)
library(caret)
library(Metrics)

# Cargar los datos procesados
datos_maraton <- read_csv("./data/processed/data_processed.csv")

# Dividir los datos en entrenamiento y prueba
set.seed(0)
indice_entrenamiento <- createDataPartition(datos_maraton$MarathonTime, p = 0.8, list = FALSE)
datos_entrenamiento <- datos_maraton[indice_entrenamiento, ]
datos_test <- datos_maraton[-indice_entrenamiento, ]

# Separar etiquetas de entrenamiento y prueba
etiquetas_entrenamiento <- datos_entrenamiento$MarathonTime
etiquetas_test <- datos_test$MarathonTime

# Quitar la columna MarathonTime de los datos de entrenamiento
datos_entrenamiento <- datos_entrenamiento %>%
  select(-MarathonTime)

# Combinar los datos de entrenamiento con las etiquetas de entrenamiento
datos_entrenamiento <- cbind(datos_entrenamiento, MarathonTime = etiquetas_entrenamiento)

# Crear el modelo de regresión lineal
modelo <- lm(MarathonTime ~ ., data = datos_entrenamiento)
# Save the model using .RData format
save(modelo, file = "./models/modelo.RData")

# Realizar predicciones en los datos de prueba
# Load the saved model
load("./models/modelo.RData")

predicciones <- predict(modelo, newdata = datos_test)

head(predicciones,3)
head(etiquetas_test,3)
# Calcular el error porcentual
error <- sqrt(mean((etiquetas_test - predicciones)^2))
cat("Error porcentual:", error * 100, "\n")

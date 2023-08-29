#!/usr/bin/env python
# coding: utf-8

# **Mi primer modelo de Machine Learning**:
# 
# Prediccion de tiempos de maraton

# **FASE 1. Preparacion de datos**

# Primero cargamos el archivo CSV
# 

# In[ ]:





# In[4]:


import io
import pandas as pd
#datos_maraton = pd.read_csv(io.BytesIO(uploaded['DatosMaratonenCSV.csv']))
datos_maraton = pd.read_csv("../data/MarathonData.csv")


# Hacemos una primera inspeccion para ver que se haya cargado bien

# In[5]:


datos_maraton.head(5)

datos_maraton.info()

datos_maraton['Wall21'] = pd.to_numeric(datos_maraton['Wall21'],errors='coerce')

datos_maraton = datos_maraton.drop(columns=['Name'])
datos_maraton = datos_maraton.drop(columns=['id'])
datos_maraton = datos_maraton.drop(columns=['Marathon'])
datos_maraton = datos_maraton.drop(columns=['CATEGORY'])

datos_maraton["CrossTraining"] = datos_maraton["CrossTraining"].fillna(0)

datos_maraton = datos_maraton.dropna(how='any')

valores_cross = {"CrossTraining":  {'ciclista 1h':1, 'ciclista 3h':2, 'ciclista 4h':3, 'ciclista 5h':4, 'ciclista 13h':5}}
datos_maraton.replace(valores_cross, inplace=True)

valores_categoria = {"Category":  {'MAM':1, 'M45':2, 'M40':3, 'M50':4, 'M55':5,'WAM':6}}
datos_maraton.replace(valores_categoria, inplace=True)

datos_maraton = datos_maraton.query('sp4week<1000')

datos_entrenamiento = datos_maraton.sample(frac=0.8,random_state=0)
datos_test = datos_maraton.drop(datos_entrenamiento.index)

etiquetas_entrenamiento = datos_entrenamiento.pop('MarathonTime')
etiquetas_test = datos_test.pop('MarathonTime')


from sklearn.linear_model import LinearRegression
import pickle
modelo = LinearRegression()
modelo.fit(datos_entrenamiento,etiquetas_entrenamiento)

with open('modelofile.pkl', 'wb') as archivo:
    pickle.dump(modelo, archivo)


# Cargar el modelo desde el archivo
with open('modelofile.pkl', 'rb') as archivo:
    modelofile = pickle.load(archivo)

predicciones = modelofile.predict(datos_test)

import numpy as np
from sklearn.metrics import mean_squared_error
error = np.sqrt(mean_squared_error(etiquetas_test, predicciones))
print("Error porcentual : %f" % (error*100))


# nuevo_corredor = pd.DataFrame(np.array([[1,400,20,0,1.4]]),columns=['Category', 'km4week','sp4week', 'CrossTraining','Wall21'])

# print(modelo.predict(nuevo_corredor))


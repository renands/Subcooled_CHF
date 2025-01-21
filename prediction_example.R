library(reticulate)
library(mgcv)
library(dplyr)
library(qgam)

# instala biblioteca spython necessarias
#reticulate::repl_python()
#!pip install pyXSteam
#!pip install iapws
#!pip install pandas
#!pip install math

source_python('functions/predict_lookup_table.py')
source_python('functions/predict_hall_mudawar_model.py')
source("functions/predict_additive_models.R")




base_teste = read.csv("data/dados_modelagem_inicial.csv")

# REALIZA PREDICAO DO MODELO LM

base_teste = predict_best_lm(base_teste)

# REALIZA PREDICAO MODELOS GLM

base_teste = predict_best_glm(base_teste,model = 1)
base_teste = predict_best_glm(base_teste,model = 2)

# REALIZA PREDICAO MODELOS GAMS

base_teste = predict_best_gam(base_teste,model = 1)
base_teste = predict_best_gam(base_teste,model = 2)
base_teste = predict_best_gam(base_teste,model = 3)
base_teste = predict_best_gam(base_teste,model = 4)
base_teste = predict_best_gam(base_teste,model = 5)
base_teste = predict_best_gam(base_teste,model = 6)
base_teste = predict_best_gam(base_teste,model = 7)

# REALIZA PREDICAO MODELOS QGAMS

base_teste = predict_best_qgam(base_teste,model = 1)
base_teste = predict_best_qgam(base_teste,model = 2)
base_teste = predict_best_qgam(base_teste,model = 3)

# REALIZA PREDICAO MODELO QGAM QUANTIL = 0.95

base_teste = predict_qgam_095(base_teste)

# REALIZA PREDICAO DO MODELO LOOKUPTABLE

base_teste = predict_lookup_table(base_teste)

# REALIZA PREDICAO DO CORRELACAO HALL-MUDAWAR
source_python('functions/predict_hall_mudawar_model.py')
base_teste = predict_hall_mudawar_correlation(base_teste)



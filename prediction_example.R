# INSTALL NECESSARY R LIBRARIES

#install.packages("reticulate","mgcv","dplyr","qgam")

library(reticulate)
library(mgcv)
library(dplyr)
library(qgam)

# INSTALL NECESSARY PYTHON LIBRARIES
# A PYTHON DISTRIBUTION IS NECESSARY TO RUN THE GROENEVELD'S AND HALL MODELS
#reticulate::repl_python()
#!pip install pyXSteam
#!pip install iapws
#!pip install pandas
#!pip install math
#!pip install numpy
#!pip install scipy

source_python('functions/predict_lookup_table.py')
source_python('functions/predict_hall_mudawar_model.py')
source("functions/predict_additive_models.R")

# INITIAL DATASET TO MAKE PREDICTIONS
# THE NECESSARY VARIABLES TO MAKE PREDICTIONS ARE
# PRESSURE - kPa
# Mass Flux kg m−2 s−1
# X_o (thermodynamic quality in the output)
# D heated diameter in mm
# L heated length in mm
# THE PREDICTIONS RETURN THE CHF IN kWm−2 
example_data = read.csv("data/dados_modelagem_inicial.csv")

# MAKE PREDICTIONS OF LM MODEL

example_data = predict_best_lm(example_data)

# MAKE PREDICTIONS OF GLM MODELS

example_data = predict_best_glm(example_data,model = 1)
example_data = predict_best_glm(example_data,model = 2)

# MAKE PREDICTIONS OF GAMS MODELS

example_data = predict_best_gam(example_data,model = 1)
example_data = predict_best_gam(example_data,model = 2)
example_data = predict_best_gam(example_data,model = 3)
example_data = predict_best_gam(example_data,model = 4)
example_data = predict_best_gam(example_data,model = 5)
example_data = predict_best_gam(example_data,model = 6)
example_data = predict_best_gam(example_data,model = 7)

# MAKE PREDICTIONS QGAMS MODELS

example_data = predict_best_qgam(example_data,model = 1)
example_data = predict_best_qgam(example_data,model = 2)
example_data = predict_best_qgam(example_data,model = 3)

# MAKE PREDICTION OF MODEL QGAM QUANTILE = 0.95

example_data = predict_qgam_095(example_data)

# MAKE PREDICTIONS OF GROENEVELD'S LOOKUP TABLE

example_data = predict_lookup_table(example_data)

# MAKE PREDICTIONS OF HALL-MUDAWAR CORRELATION
example_data = predict_hall_mudawar_correlation(example_data)



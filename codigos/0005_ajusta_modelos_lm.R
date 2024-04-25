library(dplyr)
library(ggplot2)
setwd("../Subcooled_CHF/dados/")
base_treino = readRDS("dados_treinamento_2.rds")
base_teste = readRDS("dados_teste_2.rds")

# Number of folds for cross-validation
k <- 10

lm_rmse_treino <- rep(0, k)
lm_rmse_teste = rep(0,k)
modelos_lm = list()


################################################################################
################## MODELO CONSIDERANDO LOG(CHF) COMO RESPOSTA ##################
################################################################################

# Perform k-fold cross-validation
for (i in 1:k) {

  # Linear regression (lm)
  lm_model <- lm(log(CHF) ~ P + G + X + L + D,
                 data = base_treino[[i]])
  
  lm_pred_treino = exp(predict(lm_model, newdata = base_treino[[i]]))
  lm_pred_teste = exp(predict(lm_model, newdata = base_teste[[i]]))
  
  lm_rmse_treino[i] = sqrt(mean((lm_pred_treino - base_treino[[i]]$CHF)^2))
  lm_rmse_teste[i] = sqrt(mean((lm_pred_teste - base_teste[[i]]$CHF)^2))

  base_treino[[i]]["predicoes_lm"] = lm_pred_treino
  base_teste[[i]]["predicoes_lm"] = lm_pred_teste
  
  modelos_lm[[i]] = lm_model
  
}

# Calculate the mean RMSE for each model
lm_mean_rmse <- mean(lm_rmse_teste)

# Print the mean RMSE for each model
cat("Mean RMSE for Linear Regression (lm):", lm_mean_rmse, "\n")

# saveRDS(base_treino,"dados_treinamento_2.rds")
# saveRDS(base_teste,"dados_teste_2.rds")
#saveRDS(modelos_lm,"modelos_lm.rds")
# 
# k <- 10
# lm_rmse_treino <- rep(0, k)
# lm_rmse_teste = rep(0,k)
# base_treino = readRDS("dados_treinamento_2.rds")
# base_teste = readRDS("dados_teste_2.rds")
# modelos_lm = readRDS("modelos_lm.rds")
# 
# for (i in 1:k){
#   
#   lm_pred_treino = exp(predict(modelos_lm[[i]], newdata = base_treino[[i]]))
#   lm_pred_teste = exp(predict(modelos_lm[[i]], newdata = base_teste[[i]]))
#   
#   lm_rmse_treino[i] = sqrt(mean((lm_pred_treino - base_treino[[i]]$CHF)^2))
#   lm_rmse_teste[i] = sqrt(mean((lm_pred_teste - base_teste[[i]]$CHF)^2))
#   
#   base_treino[[i]]["predicoes_lm"] = lm_pred_treino
#   base_teste[[i]]["predicoes_lm"] = lm_pred_teste
#   
# }
# 
# # Calculate the mean RMSE for each model
# lm_mean_rmse <- mean(lm_rmse_teste)
# 
# # Print the mean RMSE for each model
# cat("Mean RMSE for Linear Regression (lm):", lm_mean_rmse, "\n")
# 

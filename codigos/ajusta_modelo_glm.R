library(dplyr)
library(ggplot2)
options(scipen=999)

base_treino_2 = read.csv("dados/base_treino.csv")
base_teste_2 = read.csv("dados/base_teste.csv")
base_modelagem = rbind(base_treino_2,base_teste_2)

base_treino = readRDS("dados/dados_treinamento.rds")
base_teste = readRDS("dados/dados_teste.rds")


## MODELO GLM COM DISTRIBUISSAO NORMAL E FUNCAO DE LIGACAO LOG ##

# Number of folds for cross-validation
k <- 10

glm_rmse_treino <- rep(0, k)
glm_rmse_teste = rep(0,k)
modelos_glm = list()


# Perform k-fold cross-validation
for (i in 1:k) {
  
  # generalized Linear regression (glm)
  glm_model <- glm(CHF ~ P + G + X + L + D,
                  data = base_treino[[i]],
                  family = gaussian(link = "log"))
  
  glm_pred_treino = exp(predict(glm_model, newdata = base_treino[[i]]))
  glm_pred_teste = exp(predict(glm_model, newdata = base_teste[[i]]))
  
  glm_rmse_treino[i] = sqrt(mean((glm_pred_treino - base_treino[[i]]$CHF)^2))
  glm_rmse_teste[i] = sqrt(mean((glm_pred_teste - base_teste[[i]]$CHF)^2))
  
  base_treino[[i]]["predicoes_glm_gauss_log"] = glm_pred_treino
  base_teste[[i]]["predicoes_glm_gauss_log"] = glm_pred_teste
  
  modelos_glm[[i]] = glm_model
  
}

# Calculate the mean RMSE for each model
glm_mean_rmse <- mean(glm_rmse_teste)

# Print the mean RMSE for each model
cat("Mean RMSE for Generalized Linear Regression (glm) - NORMAL DIST - LOG LINK:", glm_mean_rmse, "\n")

#saveRDS(base_treino,"dados/dados_treinamento.rds")
#saveRDS(base_teste,"dados/dados_teste.rds")
#saveRDS(modelos_glm,"dados/modelos_glm_gauss_log.rds")

### modelo glm distribuicao gamma com link log

k <- 10

glm_rmse_treino <- rep(0, k)
glm_rmse_teste = rep(0,k)
modelos_glm = list()

# Perform k-fold cross-validation
for (i in 1:k) {
  
  # generalized Linear regression (glm)
  glm_model <- glm(CHF ~ P + G + X + L + D,
                   data = base_treino[[i]],
                   family = Gamma(link = "log"))
  
  glm_pred_treino = exp(predict(glm_model, newdata = base_treino[[i]]))
  glm_pred_teste = exp(predict(glm_model, newdata = base_teste[[i]]))
  
  glm_rmse_treino[i] = sqrt(mean((glm_pred_treino - base_treino[[i]]$CHF)^2))
  glm_rmse_teste[i] = sqrt(mean((glm_pred_teste - base_teste[[i]]$CHF)^2))
  
  base_treino[[i]]["predicoes_glm_gamma_log"] = glm_pred_treino
  base_teste[[i]]["predicoes_glm_gamma_log"] = glm_pred_teste
  
  modelos_glm[[i]] = glm_model
  
}

# Calculate the mean RMSE for each model
glm_mean_rmse <- mean(glm_rmse_teste)

# Print the mean RMSE for each model
cat("Mean RMSE for Generalized Linear Regression (glm) - GAMMA DIST - LOG LINK:", glm_mean_rmse, "\n")


#saveRDS(base_treino,"dados/dados_treinamento.rds")
#saveRDS(base_teste,"dados/dados_teste.rds")
#saveRDS(modelos_glm,"dados/modelos_glm_gamma_log.rds")



## modelo gamma com log link com interacoes de 2 grau

k <- 10

glm_rmse_treino <- rep(0, k)
glm_rmse_teste = rep(0,k)
modelos_glm = list()

# Perform k-fold cross-validation
for (i in 1:k) {
  
  # generalized Linear regression (glm)
  glm_model <- glm(CHF ~ (P + G + X + L + D)^2,
                   data = base_treino[[i]],
                   family = Gamma(link = "log"))
  
  glm_pred_treino = exp(predict(glm_model, newdata = base_treino[[i]]))
  glm_pred_teste = exp(predict(glm_model, newdata = base_teste[[i]]))
  
  glm_rmse_treino[i] = sqrt(mean((glm_pred_treino - base_treino[[i]]$CHF)^2))
  glm_rmse_teste[i] = sqrt(mean((glm_pred_teste - base_teste[[i]]$CHF)^2))
  
  base_treino[[i]]["preds_glm_gamma_log_inter"] = glm_pred_treino
  base_teste[[i]]["preds_glm_gamma_log_inter"] = glm_pred_teste
  
  modelos_glm[[i]] = glm_model
  
}

# Calculate the mean RMSE for each model
glm_mean_rmse <- mean(glm_rmse_teste)

# Print the mean RMSE for each model
cat("Mean RMSE for Generalized Linear Regression (glm) - GAMMA DIST - LOG LINK - INTERACOES 2º GRAU", glm_mean_rmse, "\n")


#saveRDS(base_treino,"dados/dados_treinamento.rds")
#saveRDS(base_teste,"dados/dados_teste.rds")
#saveRDS(modelos_glm,"dados/modelos_glm_gamma_log_inter.rds")

#### modelo com distribuicao normal e link log com interacoes de 2º grau


k <- 10

glm_rmse_treino <- rep(0, k)
glm_rmse_teste = rep(0,k)
modelos_glm = list()


# Perform k-fold cross-validation
for (i in 1:k) {
  
  # generalized Linear regression (glm)
  glm_model <- glm(CHF ~ (P + G + X + L + D)^2,
                   data = base_treino[[i]],
                   family = gaussian(link = "log"))
  
  glm_pred_treino = exp(predict(glm_model, newdata = base_treino[[i]]))
  glm_pred_teste = exp(predict(glm_model, newdata = base_teste[[i]]))
  
  glm_rmse_treino[i] = sqrt(mean((glm_pred_treino - base_treino[[i]]$CHF)^2))
  glm_rmse_teste[i] = sqrt(mean((glm_pred_teste - base_teste[[i]]$CHF)^2))
  
  base_treino[[i]]["preds_glm_gauss_log_inter"] = glm_pred_treino
  base_teste[[i]]["preds_glm_gauss_log_inter"] = glm_pred_teste
  
  modelos_glm[[i]] = glm_model
  
}

# Calculate the mean RMSE for each model
glm_mean_rmse <- mean(glm_rmse_teste)

# Print the mean RMSE for each model
cat("Mean RMSE for Generalized Linear Regression (glm) - NORMAL DIST - LOG LINK:", glm_mean_rmse, "\n")

saveRDS(base_treino,"dados/dados_treinamento.rds")
saveRDS(base_teste,"dados/dados_teste.rds")
saveRDS(modelos_glm,"dados/modelos_glm_gauss_log_inter.rds")

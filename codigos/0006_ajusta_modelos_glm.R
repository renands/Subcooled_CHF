library(dplyr)
library(ggplot2)
#setwd("../Subcooled_CHF/dados/")
base_treino = readRDS("dados_treinamento_2.rds")
base_teste = readRDS("dados_teste_2.rds")
#base_validacao = read.csv("dados_validacao_2.csv",sep = ",",dec = ".")

################################################################################
######### MODELO GLM COM DISTRIBUISSAO NORMAL E FUNCAO DE LIGACAO LOG ##########
################################################################################

# # Number of folds for cross-validation
# k <- 10
# 
# glm_rmse_treino <- rep(0, k)
# glm_rmse_teste = rep(0,k)
# modelos_glm = list()
# 
# 
# # Perform k-fold cross-validation
# for (i in 1:k) {
# 
#   # generalized Linear regression (glm)
#   glm_model <- glm(CHF ~ P + G + X + L + D,
#                   data = base_treino[[i]],
#                   family = gaussian(link = "log"))
# 
#   glm_pred_treino = exp(predict(glm_model, newdata = base_treino[[i]]))
#   glm_pred_teste = exp(predict(glm_model, newdata = base_teste[[i]]))
# 
#   glm_rmse_treino[i] = sqrt(mean((glm_pred_treino - base_treino[[i]]$CHF)^2))
#   glm_rmse_teste[i] = sqrt(mean((glm_pred_teste - base_teste[[i]]$CHF)^2))
# 
#   base_treino[[i]]["predicoes_glm_gauss_log"] = glm_pred_treino
#   base_teste[[i]]["predicoes_glm_gauss_log"] = glm_pred_teste
# 
#   modelos_glm[[i]] = glm_model
# 
# }

# 
# glm_pred_validacao = format(exp(predict(glm_model, newdata = base_validacao)),scientific = FALSE)
# base_validacao["predicoes_glm_gauss_log"] = glm_pred_validacao
# 
# 
# saveRDS(base_treino,"dados_treinamento_2.rds")
# saveRDS(base_teste,"dados_teste_2.rds")
# saveRDS(modelos_glm,"modelos_glm_gauss_log.rds")
# write.csv(base_validacao,"dados_validacao_2.csv",row.names = FALSE)
# 




### modelo glm distribuicao gamma com link log

# k <- 10
# 
# glm_rmse_treino <- rep(0, k)
# glm_rmse_teste = rep(0,k)
# modelos_glm = list()
# 
# # Perform k-fold cross-validation
# for (i in 1:k) {
# 
#   # generalized Linear regression (glm)
#   glm_model <- glm(CHF ~ P + G + X + L + D,
#                    data = base_treino[[i]],
#                    family = Gamma(link = "log"))
# 
#   glm_pred_treino = exp(predict(glm_model, newdata = base_treino[[i]]))
#   glm_pred_teste = exp(predict(glm_model, newdata = base_teste[[i]]))
# 
#   glm_rmse_treino[i] = sqrt(mean((glm_pred_treino - base_treino[[i]]$CHF)^2))
#   glm_rmse_teste[i] = sqrt(mean((glm_pred_teste - base_teste[[i]]$CHF)^2))
# 
#   base_treino[[i]]["predicoes_glm_gamma_log"] = glm_pred_treino
#   base_teste[[i]]["predicoes_glm_gamma_log"] = glm_pred_teste
# 
#   modelos_glm[[i]] = glm_model
# 
# }
# 
# 
# glm_pred_validacao = format(exp(predict(glm_model, newdata = base_validacao)),scientific = FALSE)
# base_validacao["predicoes_glm_gamma_log"] = glm_pred_validacao
# 
# 
# saveRDS(base_treino,"dados_treinamento_2.rds")
# saveRDS(base_teste,"dados_teste_2.rds")
# saveRDS(modelos_glm,"modelos_glm_gamma_log.rds")
# write.csv(base_validacao,"dados_validacao_2.csv",row.names = FALSE)








## modelo gamma com log link com interacoes de 2 grau

# k <- 10
# 
# glm_rmse_treino <- rep(0, k)
# glm_rmse_teste = rep(0,k)
# modelos_glm = list()
# 
# # Perform k-fold cross-validation
# for (i in 1:k) {
# 
#   # generalized Linear regression (glm)
#   glm_model <- glm(CHF ~ (P + G + X + L + D)^2,
#                    data = base_treino[[i]],
#                    family = Gamma(link = "log"))
# 
#   glm_pred_treino = exp(predict(glm_model, newdata = base_treino[[i]]))
#   glm_pred_teste = exp(predict(glm_model, newdata = base_teste[[i]]))
# 
#   glm_rmse_treino[i] = sqrt(mean((glm_pred_treino - base_treino[[i]]$CHF)^2))
#   glm_rmse_teste[i] = sqrt(mean((glm_pred_teste - base_teste[[i]]$CHF)^2))
# 
#   base_treino[[i]]["preds_glm_gamma_log_inter"] = glm_pred_treino
#   base_teste[[i]]["preds_glm_gamma_log_inter"] = glm_pred_teste
# 
#   modelos_glm[[i]] = glm_model
# 
# }
# 
# glm_pred_validacao = format(exp(predict(glm_model, newdata = base_validacao)),scientific = FALSE)
# base_validacao["preds_glm_gamma_log_inter"] = glm_pred_validacao
# 
# 
# saveRDS(base_treino,"dados_treinamento_2.rds")
# saveRDS(base_teste,"dados_teste_2.rds")
# saveRDS(modelos_glm,"modelos_glm_gamma_log_inter.rds")
# write.csv(base_validacao,"dados_validacao_2.csv",row.names = FALSE)













#### modelo com distribuicao normal e link log com interacoes de 2º grau


# k <- 10
# 
# glm_rmse_treino <- rep(0, k)
# glm_rmse_teste = rep(0,k)
# modelos_glm = list()
# 
# 
# # Perform k-fold cross-validation
# for (i in 1:k) {
#   
#   # generalized Linear regression (glm)
#   glm_model <- glm(CHF ~ (P + G + X + L + D)^2,
#                    data = base_treino[[i]],
#                    family = gaussian(link = "log"))
#   
#   glm_pred_treino = exp(predict(glm_model, newdata = base_treino[[i]]))
#   glm_pred_teste = exp(predict(glm_model, newdata = base_teste[[i]]))
#   
#   glm_rmse_treino[i] = sqrt(mean((glm_pred_treino - base_treino[[i]]$CHF)^2))
#   glm_rmse_teste[i] = sqrt(mean((glm_pred_teste - base_teste[[i]]$CHF)^2))
#   
#   base_treino[[i]]["preds_glm_gauss_log_inter"] = glm_pred_treino
#   base_teste[[i]]["preds_glm_gauss_log_inter"] = glm_pred_teste
#   
#   modelos_glm[[i]] = glm_model
#   
# }
# 
# glm_pred_validacao = format(exp(predict(glm_model, newdata = base_validacao)),scientific = FALSE)
# base_validacao["preds_glm_gauss_log_inter"] = glm_pred_validacao
# 
# 
# 
# saveRDS(base_treino,"dados_treinamento_2.rds")
# saveRDS(base_teste,"dados_teste_2.rds")
# saveRDS(modelos_glm,"modelos_glm_gauss_log_inter.rds")
# write.csv(base_validacao,"dados_validacao_2.csv",row.names = FALSE)



#########################################################
################# BIBLIOTECAS ###########################
#########################################################
options(scipen=999)
library(mgcv)
library(dplyr)
library(janitor)
library(ggplot2)
library(ggpubr)
library(GGally)
library(qgam)
library(mgcViz)
library(tune)


setwd("../Subcooled_CHF/dados/")
base_treino = readRDS("dados_treinamento.rds")
base_teste = readRDS("dados_teste.rds")



#########################################################
####################  GAMS GAMMA ########################
#########################################################


# modelo gam com distribuicao gamma e log link
k <- 10

gam_rmse_treino <- rep(0, k)
gam_rmse_teste = rep(0,k)
modelos_gam = list()


# Perform k-fold cross-validation
for (i in 1:k) {
  
  gams_model = gam(CHF ~
                     s(P,k=50,bs = "tp") +
                     s(X,k=50,bs = "tp") +
                     s(G,k=50,bs = "tp") +
                     te(L,D,k=30,bs = "tp"),
                   data = base_treino[[i]],
                   #gamma = 1.5,
                   method = "REML",
                   family = Gamma(link = "log")
  )
  
  gam_pred_treino = exp(predict(gams_model, newdata = base_treino[[i]]))
  gam_pred_teste = exp(predict(gams_model, newdata = base_teste[[i]]))
  
  gam_rmse_treino[i] = sqrt(mean((gam_pred_treino - base_treino[[i]]$CHF)^2))
  gam_rmse_teste[i] = sqrt(mean((gam_pred_teste - base_teste[[i]]$CHF)^2))
  
  base_treino[[i]]["predicoes_gam_tp_gamma_log"] = gam_pred_treino
  base_teste[[i]]["predicoes_gam_tp_gamma_log"] = gam_pred_teste
  
  modelos_gam[[i]] = gams_model
  
}

# Calculate the mean RMSE for each model
gam_mean_rmse <- mean(gam_rmse_teste)

# Print the mean RMSE for each model
cat("Mean RMSE for Gam - Tp - GAMMA DIST - LOG LINK:", gam_mean_rmse, "\n")


gam.check(gams_model)
summary(gams_model)


#saveRDS(base_treino,"dados_treinamento.rds")
#saveRDS(base_teste,"dados_teste.rds")
#saveRDS(modelos_gam,"modelos_gam_gamma_log_tp.rds")

# k <- 10
# modelos_gam = readRDS("modelos_gam_gamma_log_tp.rds")
# 
# for (i in 1:k){
# 
#   gam_pred_treino = exp(predict(modelos_gam[[i]], newdata = base_treino[[i]]))
#   gam_pred_teste = exp(predict(modelos_gam[[i]], newdata = base_teste[[i]]))
# 
#   base_treino[[i]]["predicoes_gam_tp_gamma_log"] = gam_pred_treino
#   base_teste[[i]]["predicoes_gam_tp_gamma_log"] = gam_pred_teste
# 
# }
# 
# saveRDS(base_treino,"dados_treinamento.rds")
# saveRDS(base_teste,"dados_teste.rds")



# modelo gam com distribuicao gamma e log link
k <- 10

gam_rmse_treino <- rep(0, k)
gam_rmse_teste = rep(0,k)
modelos_gam = list()


# Perform k-fold cross-validation
for (i in 1:k) {
  
  gams_model = gam(CHF ~
                     s(P,k=50,bs = "ad") +
                     s(X,k=50,bs = "ad") +
                     s(G,k=50,bs = "ad") +
                     s(D,k=50,bs="ad")+
                     s(L,k = 50,bs = "ad"),
                   data = base_treino[[i]],
                   #gamma = 1.5,
                   method = "REML",
                   family = Gamma(link = "log")
  )
  
  gam_pred_treino = exp(predict(gams_model, newdata = base_treino[[i]]))
  gam_pred_teste = exp(predict(gams_model, newdata = base_teste[[i]]))
  
  gam_rmse_treino[i] = sqrt(mean((gam_pred_treino - base_treino[[i]]$CHF)^2))
  gam_rmse_teste[i] = sqrt(mean((gam_pred_teste - base_teste[[i]]$CHF)^2))
  
  base_treino[[i]]["predicoes_gam_simples_ad_gamma_log"] = gam_pred_treino
  base_teste[[i]]["predicoes_gam_simples_ad_gamma_log"] = gam_pred_teste
  
  modelos_gam[[i]] = gams_model
  
}

# Calculate the mean RMSE for each model
gam_mean_rmse <- mean(gam_rmse_teste)

# Print the mean RMSE for each model
cat("Mean RMSE for Gam - s(ad) - GAMMA DIST - LOG LINK:", gam_mean_rmse, "\n")


gam.check(gams_model)
summary(gams_model)


#saveRDS(base_treino,"dados_treinamento.rds")
#saveRDS(base_teste,"dados_teste.rds")
#saveRDS(modelos_gam,"modelos_gam_gamma_log_ad_simples.rds")

# k <- 10
# modelos_gam = readRDS("modelos_gam_gamma_log_ad_simples.rds")
# 
# for (i in 1:k){
# 
#   gam_pred_treino = exp(predict(modelos_gam[[i]], newdata = base_treino[[i]]))
#   gam_pred_teste = exp(predict(modelos_gam[[i]], newdata = base_teste[[i]]))
# 
#   base_treino[[i]]["predicoes_gam_simples_ad_gamma_log"] = gam_pred_treino
#   base_teste[[i]]["predicoes_gam_simples_ad_gamma_log"] = gam_pred_teste
# 
# }
# 
# saveRDS(base_treino,"dados_treinamento.rds")
# saveRDS(base_teste,"dados_teste.rds")











# modelo gam com distribuicao gamma e log link
k <- 10

gam_rmse_treino <- rep(0, k)
gam_rmse_teste = rep(0,k)
modelos_gam = list()


# Perform k-fold cross-validation
for (i in 1:k) {
  
  gams_model = gam(CHF ~
                     s(P,k=50,bs = "tp") +
                     s(X,k=50,bs = "tp") +
                     s(G,k=50,bs = "tp") +
                     s(D,k=50,bs="tp")+
                     s(L,k = 50,bs = "tp"),
                   data = base_treino[[i]],
                   #gamma = 1.5,
                   method = "REML",
                   family = Gamma(link = "log")
  )
  
  gam_pred_treino = exp(predict(gams_model, newdata = base_treino[[i]]))
  gam_pred_teste = exp(predict(gams_model, newdata = base_teste[[i]]))
  
  gam_rmse_treino[i] = sqrt(mean((gam_pred_treino - base_treino[[i]]$CHF)^2))
  gam_rmse_teste[i] = sqrt(mean((gam_pred_teste - base_teste[[i]]$CHF)^2))
  
  base_treino[[i]]["predicoes_gam_simples_tp_gamma_log"] = gam_pred_treino
  base_teste[[i]]["predicoes_gam_simples_tp_gamma_log"] = gam_pred_teste
  
  modelos_gam[[i]] = gams_model
  
}

# Calculate the mean RMSE for each model
gam_mean_rmse <- mean(gam_rmse_teste)

# Print the mean RMSE for each model
cat("Mean RMSE for Gam - s(tp) - GAMMA DIST - LOG LINK:", gam_mean_rmse, "\n")


gam.check(gams_model)
summary(gams_model)


# saveRDS(base_treino,"dados_treinamento.rds")
# saveRDS(base_teste,"dados_teste.rds")
# saveRDS(modelos_gam,"modelos_gam_gamma_log_tp_simples.rds")

# 
# modelos_gam = readRDS("modelos_gam_gamma_log_tp_simples.rds")
# 
# for (i in 1:k){
# 
#   gam_pred_treino = exp(predict(modelos_gam[[i]], newdata = base_treino[[i]]))
#   gam_pred_teste = exp(predict(modelos_gam[[i]], newdata = base_teste[[i]]))
# 
#   base_treino[[i]]["predicoes_gam_simples_tp_gamma_log"] = gam_pred_treino
#   base_teste[[i]]["predicoes_gam_simples_tp_gamma_log"] = gam_pred_teste
# 
# }
# 
# saveRDS(base_treino,"dados_treinamento.rds")
# saveRDS(base_teste,"dados_teste.rds")











# modelo gam com distribuicao gamma e log link
k <- 10

gam_rmse_treino <- rep(0, k)
gam_rmse_teste = rep(0,k)
modelos_gam = list()


# Perform k-fold cross-validation
for (i in 1:k) {
  
  gams_model = gam(CHF ~
                     s(P,k=50,bs = "cr") +
                     s(X,k=50,bs = "cr") +
                     s(G,k=50,bs = "cr") +
                     s(D,k=50,bs="cr")+
                     s(L,k = 50,bs = "cr"),
                   data = base_treino[[i]],
                   #gamma = 1.5,
                   method = "REML",
                   family = Gamma(link = "log")
  )
  
  gam_pred_treino = exp(predict(gams_model, newdata = base_treino[[i]]))
  gam_pred_teste = exp(predict(gams_model, newdata = base_teste[[i]]))
  
  gam_rmse_treino[i] = sqrt(mean((gam_pred_treino - base_treino[[i]]$CHF)^2))
  gam_rmse_teste[i] = sqrt(mean((gam_pred_teste - base_teste[[i]]$CHF)^2))
  
  base_treino[[i]]["predicoes_gam_simples_cr_gamma_log"] = gam_pred_treino
  base_teste[[i]]["predicoes_gam_simples_cr_gamma_log"] = gam_pred_teste
  
  modelos_gam[[i]] = gams_model
  
}

# Calculate the mean RMSE for each model
gam_mean_rmse <- mean(gam_rmse_teste)

# Print the mean RMSE for each model
cat("Mean RMSE for Gam - s(cr) - GAMMA DIST - LOG LINK:", gam_mean_rmse, "\n")


gam.check(gams_model)
summary(gams_model)


# saveRDS(base_treino,"dados_treinamento.rds")
# saveRDS(base_teste,"dados_teste.rds")
# saveRDS(modelos_gam,"modelos_gam_gamma_log_cr_simples.rds")


# modelos_gam = readRDS("modelos_gam_gamma_log_cr_simples.rds")
# 
# for (i in 1:k){
# 
#   gam_pred_treino = exp(predict(modelos_gam[[i]], newdata = base_treino[[i]]))
#   gam_pred_teste = exp(predict(modelos_gam[[i]], newdata = base_teste[[i]]))
# 
#   base_treino[[i]]["predicoes_gam_simples_cr_gamma_log"] = gam_pred_treino
#   base_teste[[i]]["predicoes_gam_simples_cr_gamma_log"] = gam_pred_teste
# 
# }
# 
# saveRDS(base_treino,"dados_treinamento.rds")
# saveRDS(base_teste,"dados_teste.rds")



#########################################################
####################  GAMS normal #######################
#########################################################


# Perform k-fold cross-validation
for (i in 1:k) {
  
  gams_model = gam(CHF ~
                     s(P,k=50,bs = "cr") +
                     s(X,k=50,bs = "cr") +
                     s(G,k=50,bs = "cr") +
                     s(D,k=50,bs="cr")+
                     s(L,k = 50,bs = "cr"),
                   data = base_treino[[i]],
                   #gamma = 1.5,
                   method = "REML",
                   family = gaussian(link = "log")
  )
  
  gam_pred_treino = exp(predict(gams_model, newdata = base_treino[[i]]))
  gam_pred_teste = exp(predict(gams_model, newdata = base_teste[[i]]))
  
  gam_rmse_treino[i] = sqrt(mean((gam_pred_treino - base_treino[[i]]$CHF)^2))
  gam_rmse_teste[i] = sqrt(mean((gam_pred_teste - base_teste[[i]]$CHF)^2))
  
  base_treino[[i]]["predicoes_gam_simples_cr_normal_log"] = gam_pred_treino
  base_teste[[i]]["predicoes_gam_simples_cr_normal_log"] = gam_pred_teste
  
  modelos_gam[[i]] = gams_model
  
}

# Calculate the mean RMSE for each model
gam_mean_rmse <- mean(gam_rmse_teste)

# Print the mean RMSE for each model
cat("Mean RMSE for Gam - s(cr) - NORMAL DIST - LOG LINK:", gam_mean_rmse, "\n")


gam.check(gams_model)
summary(gams_model)


#saveRDS(base_treino,"dados_treinamento.rds")
#saveRDS(base_teste,"dados_teste.rds")
#saveRDS(modelos_gam,"modelos_gam_normal_log_cr_simples.rds")

# modelos_gam = readRDS("modelos_gam_normal_log_cr_simples.rds")
# 
# for (i in 1:k){
# 
#   gam_pred_treino = exp(predict(modelos_gam[[i]], newdata = base_treino[[i]]))
#   gam_pred_teste = exp(predict(modelos_gam[[i]], newdata = base_teste[[i]]))
# 
#   base_treino[[i]]["predicoes_gam_simples_cr_normal_log"] = gam_pred_treino
#   base_teste[[i]]["predicoes_gam_simples_cr_normal_log"] = gam_pred_teste
# 
# }
# 
# saveRDS(base_treino,"dados_treinamento.rds")
# saveRDS(base_teste,"dados_teste.rds")


# modelo gam com distribuicao normal e log link
k <- 10

gam_rmse_treino <- rep(0, k)
gam_rmse_teste = rep(0,k)
modelos_gam = list()


# Perform k-fold cross-validation
for (i in 1:k) {
  
  gams_model = gam(CHF ~
                     s(P,k=50,bs = "ad") +
                     s(X,k=50,bs = "ad") +
                     s(G,k=50,bs = "ad") +
                     s(D,k=50,bs="ad")+
                     s(L,k = 50,bs = "ad"),
                   data = base_treino[[i]],
                   #gamma = 1.5,
                   method = "REML",
                   family = gaussian(link = "log")
  )
  
  gam_pred_treino = exp(predict(gams_model, newdata = base_treino[[i]]))
  gam_pred_teste = exp(predict(gams_model, newdata = base_teste[[i]]))
  
  gam_rmse_treino[i] = sqrt(mean((gam_pred_treino - base_treino[[i]]$CHF)^2))
  gam_rmse_teste[i] = sqrt(mean((gam_pred_teste - base_teste[[i]]$CHF)^2))
  
  base_treino[[i]]["predicoes_gam_simples_ad_normal_log"] = gam_pred_treino
  base_teste[[i]]["predicoes_gam_simples_ad_normal_log"] = gam_pred_teste
  
  modelos_gam[[i]] = gams_model
  
}


# Calculate the mean RMSE for each model
gam_mean_rmse <- mean(gam_rmse_teste)

# Print the mean RMSE for each model
cat("Mean RMSE for Gam - s(ad) - NORMAL DIST - LOG LINK:", gam_mean_rmse, "\n")


gam.check(gams_model)
summary(gams_model)


# saveRDS(base_treino,"dados_treinamento.rds")
# saveRDS(base_teste,"dados_teste.rds")
# saveRDS(modelos_gam,"modelos_gam_normal_log_ad_simples.rds")


# modelos_gam = readRDS("modelos_gam_normal_log_ad_simples.rds")
# 
# for (i in 1:k){
# 
#   gam_pred_treino = exp(predict(modelos_gam[[i]], newdata = base_treino[[i]]))
#   gam_pred_teste = exp(predict(modelos_gam[[i]], newdata = base_teste[[i]]))
# 
#   base_treino[[i]]["predicoes_gam_simples_ad_normal_log"] = gam_pred_treino
#   base_teste[[i]]["predicoes_gam_simples_ad_normal_log"] = gam_pred_teste
# 
# }
# 
# saveRDS(base_treino,"dados_treinamento.rds")
# saveRDS(base_teste,"dados_teste.rds")



# modelo gam com distribuicao normal e log link
k <- 10

gam_rmse_treino <- rep(0, k)
gam_rmse_teste = rep(0,k)
modelos_gam = list()


# Perform k-fold cross-validation
for (i in 1:k) {
  
  gams_model = gam(CHF ~
                     s(P,k=50,bs = "tp") +
                     s(X,k=50,bs = "tp") +
                     s(G,k=50,bs = "tp") +
                     s(D,k=50,bs="tp")+
                     s(L,k = 50,bs = "tp"),
                   data = base_treino[[i]],
                   #gamma = 1.5,
                   method = "REML",
                   family = gaussian(link = "log")
  )
  
  gam_pred_treino = exp(predict(gams_model, newdata = base_treino[[i]]))
  gam_pred_teste = exp(predict(gams_model, newdata = base_teste[[i]]))
  
  gam_rmse_treino[i] = sqrt(mean((gam_pred_treino - base_treino[[i]]$CHF)^2))
  gam_rmse_teste[i] = sqrt(mean((gam_pred_teste - base_teste[[i]]$CHF)^2))
  
  base_treino[[i]]["predicoes_gam_simples_tp_normal_log"] = gam_pred_treino
  base_teste[[i]]["predicoes_gam_simples_tp_normal_log"] = gam_pred_teste
  
  modelos_gam[[i]] = gams_model
  
}

# Calculate the mean RMSE for each model
gam_mean_rmse <- mean(gam_rmse_teste)

# Print the mean RMSE for each model
cat("Mean RMSE for Gam - s(tp) - NORMAL DIST - LOG LINK:", gam_mean_rmse, "\n")


gam.check(gams_model)
summary(gams_model)


# saveRDS(base_treino,"dados_treinamento.rds")
# saveRDS(base_teste,"dados_teste.rds")
# saveRDS(modelos_gam,"modelos_gam_normal_log_tp_simples.rds")

# modelos_gam = readRDS("modelos_gam_normal_log_tp_simples.rds")
# 
# for (i in 1:k){
# 
#   gam_pred_treino = exp(predict(modelos_gam[[i]], newdata = base_treino[[i]]))
#   gam_pred_teste = exp(predict(modelos_gam[[i]], newdata = base_teste[[i]]))
# 
#   base_treino[[i]]["predicoes_gam_simples_tp_normal_log"] = gam_pred_treino
#   base_teste[[i]]["predicoes_gam_simples_tp_normal_log"] = gam_pred_teste
# 
# }
# 
# saveRDS(base_treino,"dados_treinamento.rds")
# saveRDS(base_teste,"dados_teste.rds")



################################################################################
################################ MODELO COM TENSOR #############################
################################################################################
# 
# modelos_gam = readRDS("modelos_gam_normal_log_cr_simples.rds")
# 
# 
# library(parallel)
# 
# nCores <- detectCores() - 2
# 
# cluster <- makeCluster(nCores)

# modelo gam com distribuicao gamma e log link
k <- 10

gam_rmse_treino <- rep(0,1)
gam_rmse_teste = rep(0,1)
modelos_gam = list()

# Perform k-fold cross-validation
for (i in 1:k) {
  print(i)
  gams_model = gam(CHF ~
                     s(P,k=15,bs = "cr") +
                     s(X,k=15,bs = "cr") +
                     s(G,k=15,bs = "cr") +
                     s(D,k=15,bs="cr")+
                     s(L,k = 15,bs = "cr") +
                     ti(P,X,bs = "cr") +
                     ti(P,G,bs = "cr") +
                     ti(P,D,bs = "cr") +
                     ti(P,L,bs = "cr") +
                     ti(X,G,bs = "cr") +
                     ti(X,D,bs = "cr") +
                     ti(X,L,bs = "cr") +
                     ti(G,D,bs = "cr") +
                     ti(G,L,bs = "cr") +
                     ti(D,L,bs = "cr"),
                   data = base_treino[[i]],
                   gamma = 1.5,
                   method = "REML",
                   family = Gamma(link = "log")
  )
  
  gam_pred_treino = exp(predict(gams_model, newdata = base_treino[[i]]))
  gam_pred_teste = exp(predict(gams_model, newdata = base_teste[[i]]))
  
  gam_rmse_treino[i] = sqrt(mean((gam_pred_treino - base_treino[[i]]$CHF)^2))
  gam_rmse_teste[i] = sqrt(mean((gam_pred_teste - base_teste[[i]]$CHF)^2))
  
  base_treino[[i]]["predicoes_gam_cr_int"] = gam_pred_treino
  base_teste[[i]]["predicoes_gam_cr_int"] = gam_pred_teste
  
  modelos_gam[[i]] = gams_model
  
}

# Calculate the mean RMSE for each model
gam_mean_rmse <- mean(gam_rmse_teste)
# Print the mean RMSE for each model
cat("Mean RMSE for Gam - cr - com iteracoes", gam_mean_rmse, "\n")


gam.check(gams_model)
summary(gams_model)



saveRDS(base_treino,"dados_treinamento.rds")
saveRDS(base_teste,"dados_teste.rds")
saveRDS(modelos_gam,"modelos_gam_cr_inter.rds")


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


# modelo qgam q 0.5
k <- 10

qgam_rmse_treino <- rep(0, k)
qgam_rmse_teste = rep(0,k)
modelos_qgam = list()


# Perform k-fold cross-validation
for (i in 1:k) {
  
  qgams_model = qgam(CHF ~
                                s(P,k=50,bs = "cr") +
                                s(G,k=50,bs = "cr") +
                                s(X,k=50,bs = "cr") +
                                s(D,k = 50,bs = "cr") +
                                s(L,k = 50,bs = "cr"), 
                              data =  base_treino[[i]],
                              qu = 0.5)
  
  
  qgam_pred_treino = predict(qgams_model, newdata = base_treino[[i]])
  qgam_pred_teste = predict(qgams_model, newdata = base_teste[[i]])
  
  qgam_rmse_treino[i] = sqrt(mean((qgam_pred_treino - base_treino[[i]]$CHF)^2))
  qgam_rmse_teste[i] = sqrt(mean((qgam_pred_teste - base_teste[[i]]$CHF)^2))
  
  base_treino[[i]]["predicoes_qgam_cr"] = qgam_pred_treino
  base_teste[[i]]["predicoes_qgam_cr"] = qgam_pred_teste
  
  modelos_qgam[[i]] = qgams_model
  
}



# Calculate the mean RMSE for each model
qgam_mean_rmse <- mean(gam_rmse_teste)

# Print the mean RMSE for each model
cat("Mean RMSE for QGam - cr - 0.5", qgam_mean_rmse, "\n")

# 
# saveRDS(base_treino,"dados_treinamento.rds")
# saveRDS(base_teste,"dados_teste.rds")
# saveRDS(modelos_qgam,"modelos_qgam_50_cr.rds")

k=10
# modelos_qgam = readRDS("modelos_qgam_50_cr.rds")
# 
# for (i in 1:k){
#   
#   gam_pred_treino = predict(modelos_qgam[[i]], newdata = base_treino[[i]])
#   gam_pred_teste = predict(modelos_qgam[[i]], newdata = base_teste[[i]])
#   
#   base_treino[[i]]["predicoes_qgam_cr"] = gam_pred_treino
#   base_teste[[i]]["predicoes_qgam_cr"] = gam_pred_teste
#   
# }
# 
# saveRDS(base_treino,"dados_treinamento.rds")
# saveRDS(base_teste,"dados_teste.rds")









# modelo qgam q 0.5
k <- 10

qgam_rmse_treino <- rep(0, k)
qgam_rmse_teste = rep(0,k)
modelos_qgam = list()


# Perform k-fold cross-validation
for (i in 1:k) {
  
  qgams_model = qgam(CHF ~
                       s(P,k=50,bs = "ad") +
                       s(G,k=50,bs = "ad") +
                       s(X,k=50,bs = "ad") +
                       s(D,k = 50,bs = "ad") +
                       s(L,k = 50,bs = "ad"), 
                     data =  base_treino[[i]],
                     qu = 0.5)
  
  
  qgam_pred_treino = predict(qgams_model, newdata = base_treino[[i]])
  qgam_pred_teste = predict(qgams_model, newdata = base_teste[[i]])
  
  qgam_rmse_treino[i] = sqrt(mean((qgam_pred_treino - base_treino[[i]]$CHF)^2))
  qgam_rmse_teste[i] = sqrt(mean((qgam_pred_teste - base_teste[[i]]$CHF)^2))
  
  base_treino[[i]]["predicoes_qgam_ad"] = qgam_pred_treino
  base_teste[[i]]["predicoes_qgam_ad"] = qgam_pred_teste
  
  modelos_qgam[[i]] = qgams_model
  
}



# Calculate the mean RMSE for each model
qgam_mean_rmse <- mean(qgam_rmse_teste)

# Print the mean RMSE for each model
cat("Mean RMSE for QGam - ad - 0.5", qgam_mean_rmse, "\n")


#saveRDS(base_treino,"dados_treinamento.rds")
#saveRDS(base_teste,"dados_teste.rds")
# saveRDS(modelos_qgam,"modelos_qgam_50_ad.rds")
# 
# 
# k=10
# modelos_qgam = readRDS("modelos_qgam_50_ad.rds")
# 
# for (i in 1:k){
# 
#   gam_pred_treino = predict(modelos_qgam[[i]], newdata = base_treino[[i]])
#   gam_pred_teste = predict(modelos_qgam[[i]], newdata = base_teste[[i]])
# 
#   base_treino[[i]]["predicoes_qgam_ad"] = gam_pred_treino
#   base_teste[[i]]["predicoes_qgam_ad"] = gam_pred_teste
# 
# }
# 
# saveRDS(base_treino,"dados_treinamento.rds")
# saveRDS(base_teste,"dados_teste.rds")







# modelo qgam q 0.5
k <- 10

qgam_rmse_treino <- rep(0, k)
qgam_rmse_teste = rep(0,k)
modelos_qgam = list()


# Perform k-fold cross-validation
for (i in 1:k) {
  
  qgams_model = qgam(CHF ~
                       s(P,k=50,bs = "tp") +
                       s(G,k=50,bs = "tp") +
                       s(X,k=50,bs = "tp") +
                       s(D,k = 50,bs = "tp") +
                       s(L,k = 50,bs = "tp"), 
                     data =  base_treino[[i]],
                     qu = 0.5)
  
  
  qgam_pred_treino = predict(qgams_model, newdata = base_treino[[i]])
  qgam_pred_teste = predict(qgams_model, newdata = base_teste[[i]])
  
  qgam_rmse_treino[i] = sqrt(mean((qgam_pred_treino - base_treino[[i]]$CHF)^2))
  qgam_rmse_teste[i] = sqrt(mean((qgam_pred_teste - base_teste[[i]]$CHF)^2))
  
  base_treino[[i]]["predicoes_qgam_tp"] = qgam_pred_treino
  base_teste[[i]]["predicoes_qgam_tp"] = qgam_pred_teste
  
  modelos_qgam[[i]] = qgams_model
  
}



# Calculate the mean RMSE for each model
qgam_mean_rmse <- mean(qgam_rmse_teste)

# Print the mean RMSE for each model
cat("Mean RMSE for QGam - tp - 0.5", qgam_mean_rmse, "\n")


# saveRDS(base_treino,"dados_treinamento.rds")
# saveRDS(base_teste,"dados_teste.rds")
# saveRDS(modelos_qgam,"modelos_qgam_50_tp.rds")

# k=10
# modelos_qgam = readRDS("modelos_qgam_50_tp.rds")
# 
# for (i in 1:k){
# 
#   gam_pred_treino = predict(modelos_qgam[[i]], newdata = base_treino[[i]])
#   gam_pred_teste = predict(modelos_qgam[[i]], newdata = base_teste[[i]])
# 
#   base_treino[[i]]["predicoes_qgam_tp"] = gam_pred_treino
#   base_teste[[i]]["predicoes_qgam_tp"] = gam_pred_teste
# 
# }
# 
# saveRDS(base_treino,"dados_treinamento.rds")
# saveRDS(base_teste,"dados_teste.rds")


################## modelo para 0.95 quantil #########
base_modelagem = read.csv("dados_modelagem_2.csv")

ggplot(base_modelagem) +
  geom_point(aes(x = P, y = CHF))

base_modelagem = base_modelagem %>%
  filter(dados_mudawar == 0)

base_modelagem = base_modelagem %>%
  arrange(P)

qus <- c(0.05, 0.25, 0.5, 0.75, 0.95)

fit <- mqgam(CHF~s(P, k = 30, bs = "cr"), 
             data = base_modelagem,
             qu = qus)

ggplot(base_modelagem) +
  geom_point(aes(x = P, y = CHF)) +
  geom_line(aes(x = P, y = qdo(fit, 0.05, predict),colour = "Q: 0.05"), alpha=0.8,linewidth = 1.5) +
  geom_line(aes(x = P, y = qdo(fit, 0.25, predict),colour = "Q: 0.25"), alpha=0.8,linewidth = 1.5) +
  geom_line(aes(x = P, y = qdo(fit, 0.5, predict),colour = "Q: 0.5"), alpha=0.8,linewidth = 1.5) +
  geom_line(aes(x = P, y = qdo(fit, 0.75, predict),colour = "Q: 0.75"), alpha=0.8,linewidth = 1.5) +
  geom_line(aes(x = P, y = qdo(fit, 0.95, predict),colour = "Q: 0.95"), alpha=0.8,linewidth = 1.5)+
#  theme(legend.position = "bottom") +
  labs(color=NULL) +
  xlab("Pressão") +
  ylab("FCC")


plot(base_modelagem$P, base_modelagem$CHF, col = "grey", ylab = "y")
for(iq in qus){ 
  lines(base_modelagem$P, qdo(fit, iq, predict))
}

set.seed(123)
#use 70% of dataset as training set and 30% as test set
sample <- sample(c(TRUE, FALSE), nrow(base_modelagem), replace=TRUE, prob=c(0.9,0.1))
treino  <- base_modelagem[sample, ]
teste   <- base_modelagem[!sample, ]



qgams_model = qgam(CHF ~
                     s(P,k=10,bs = "cr") +
                     s(G,k=10,bs = "cr") +
                     s(X,k=10,bs = "cr") +
                     s(D,k = 20,bs = "cr") +
                     s(L,k = 25,bs = "cr") +
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
                   data =  treino,
                   multicore = TRUE,
                   ncores = 3,
                   qu = 0.95)

#saveRDS(qgams_model,"modelos_qgam_95_inter.rds")
qgams_model = readRDS("modelos_qgam_95_inter.rds")

summary(qgams_model)
check.qgam(qgams_model)
#base_modelagem_2= base_modelagem
base_modelagem = base_modelagem_2
base_modelagem = base_modelagem %>%
  #arrange(CHF) %>%
  slice(1500:2000)

pred <- predict(qgams_model , newdata = base_modelagem, se=TRUE)
plot(seq(1,501), base_modelagem$CHF, xlab = "Observação",
     ylab = "FCC"#,ylim = c(0,3000)
     )
lines(seq(1,501), pred$fit, lwd = 1,col = 2)
lines(seq(1,501), pred$fit + 2*pred$se.fit, lwd = 1, col = 2)
lines(seq(1,501), pred$fit - 2*pred$se.fit, lwd = 1, col = 2) 




qgams_model = getViz(qgams_model)

# interpretacao e analise do modelo
check1D(qgams_model, "P") + l_gridQCheck1D(qu = 0.95)
check1D(qgams_model, "G") + l_gridQCheck1D(qu = 0.95)
check1D(qgams_model, "X") + l_gridQCheck1D(qu = 0.95)
check1D(qgams_model, "D") + l_gridQCheck1D(qu = 0.95)
check1D(qgams_model, "L") + l_gridQCheck1D(qu = 0.95)
 
 
cqcheck(obj = modelo_qgam, v = c("D_mm", "L_mm"),
         X = dados_gro, 
         y = dados_gro$CHF,
         scatter = TRUE)
 


# # visao mais detalhada das funcoes de suavizacao
# 
b = getViz(qgams_model)
 
 o <- plot( sm(b, 1) )
 o + l_fitLine(colour = "red") + l_rug(mapping = aes(x=x, y=y), alpha = 0.8) +
   l_ciLine(mul = 5, colour = "blue", linetype = 2) +
   l_points(shape = 19, size = 1, alpha = 0.1) +
   theme_classic()


 o <- plot( sm(b, 2) )
 o + l_fitLine(colour = "red") + l_rug(mapping = aes(x=x, y=y), alpha = 0.8) +
   l_ciLine(mul = 5, colour = "blue", linetype = 2) +
   l_points(shape = 19, size = 1, alpha = 0.1) +
   theme_classic()


 o <- plot( sm(b, 3) )
 o + l_fitLine(colour = "red") + l_rug(mapping = aes(x=x, y=y), alpha = 0.8) +
   l_ciLine(mul = 5, colour = "blue", linetype = 2) +
   l_points(shape = 19, size = 1, alpha = 0.1) +
   theme_classic()

 o <- plot( sm(b, 4) )
 o + l_fitLine(colour = "red") + l_rug(mapping = aes(x=x, y=y), alpha = 0.8) +
   l_ciLine(mul = 5, colour = "blue", linetype = 2) +
   l_points(shape = 19, size = 1, alpha = 0.1) +
   theme_classic()

 o <- plot( sm(b, 5) )
 o + l_fitLine(colour = "red") + l_rug(mapping = aes(x=x, y=y), alpha = 0.8) +
   l_ciLine(mul = 5, colour = "blue", linetype = 2) +
   l_points(shape = 19, size = 1, alpha = 0.1) +
   theme_classic()
 


# check1D(modelo_qgam[[1]], "P_kpa") + l_gridQCheck1D(qu = 0.05)
# check1D(modelo_qgam[[2]], "P_kpa") + l_gridQCheck1D(qu = 0.5)
# check1D(modelo_qgam[[3]], "P_kpa") + l_gridQCheck1D(qu = 0.95)
#
#
#
# check1D(modelo_qgam[[1]], "G") + l_gridQCheck1D(qu = 0.05)
# check1D(modelo_qgam[[1]], "X_chf") + l_gridQCheck1D(qu = 0.05)
# check1D(modelo_qgam[[1]], "D_mm") + l_gridQCheck1D(qu = 0.05)
# check1D(modelo_qgam[[1]], "L_mm") + l_gridQCheck1D(qu = 0.05)
#
# check1D(modelo_qgam[[2]], "G") + l_gridQCheck1D(qu = 0.5)
# check1D(modelo_qgam[[2]], "X_chf") + l_gridQCheck1D(qu = 0.5)
# check1D(modelo_qgam[[2]], "D_mm") + l_gridQCheck1D(qu = 0.5)
# check1D(modelo_qgam[[2]], "L_mm") + l_gridQCheck1D(qu = 0.5)
#
#
#
# cqcheck(obj = modelo_qgam[[1]], v = c("D_mm", "L_mm"),
#         X = dados_gro,
#         y = dados_gro$CHF,
#         scatter = TRUE)
#
# cqcheck(obj = modelo_qgam[[2]], v = c("D_mm", "L_mm"),
#         X = dados_gro,
#         y = dados_gro$CHF,
#         scatter = TRUE)
#
#
# cqcheck(obj = modelo_qgam[[3]], v = c("D_mm", "L_mm"),
#         X = dados_gro,
#         y = dados_gro$CHF,
#         scatter = TRUE)
#
#
# check(modelo_qgam[[1]])
# check(modelo_qgam[[2]])
# check(modelo_qgam[[3]])
#
#
# summary(modelo_qgam[[1]])
# summary(modelo_qgam[[2]])
# summary(modelo_qgam[[3]])
#
#
# check(modelo_qgam[[1]]$calibr, 2)
# check(modelo_qgam[[2]]$calibr, 2)
# check(modelo_qgam[[3]]$calibr, 2)


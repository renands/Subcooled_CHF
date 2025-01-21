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
library(gridExtra)


base_treino = readRDS("dados_treinamento_2.rds")
base_teste = readRDS("dados_teste_2.rds")
base_validacao = read.csv("dados_validacao_2.csv",sep = ",",dec = ".")

# 
# # modelo qgam q 0.5
# k <- 10
# 
# qgam_rmse_treino <- rep(0, k)
# qgam_rmse_teste = rep(0,k)
# modelos_qgam = list()
# 
# 
# # Perform k-fold cross-validation
# for (i in 1:k) {
# 
#   qgams_model = qgam(CHF ~
#                                 s(P,k=50,bs = "cr") +
#                                 s(G,k=50,bs = "cr") +
#                                 s(X,k=50,bs = "cr") +
#                                 s(D,k = 50,bs = "cr") +
#                                 s(L,k = 50,bs = "cr"),
#                               data =  base_treino[[i]],
#                               multicore = TRUE,
#                               ncores = 6,
#                               qu = 0.5)
# 
# 
#   qgam_pred_treino = predict(qgams_model, newdata = base_treino[[i]])
#   qgam_pred_teste = predict(qgams_model, newdata = base_teste[[i]])
# 
#   qgam_rmse_treino[i] = sqrt(mean((qgam_pred_treino - base_treino[[i]]$CHF)^2))
#   qgam_rmse_teste[i] = sqrt(mean((qgam_pred_teste - base_teste[[i]]$CHF)^2))
# 
#   base_treino[[i]]["predicoes_qgam_cr"] = qgam_pred_treino
#   base_teste[[i]]["predicoes_qgam_cr"] = qgam_pred_teste
# 
#   modelos_qgam[[i]] = qgams_model
# 
# }
# 
# 
# qgam_pred_validacao = format(predict(qgams_model, newdata = base_validacao),scientific = FALSE)
# base_validacao["predicoes_qgam_cr"] = qgam_pred_validacao
# 
# 
# saveRDS(base_treino,"dados_treinamento_2.rds")
# saveRDS(base_teste,"dados_teste_2.rds")
# saveRDS(modelos_qgam,"modelos_qgam_50_cr.rds")
# write.csv(base_validacao,"dados_validacao_2.csv",row.names = FALSE)



#k=10
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
# k <- 10
# 
# qgam_rmse_treino <- rep(0, k)
# qgam_rmse_teste = rep(0,k)
# modelos_qgam = list()
# 
# 
# # Perform k-fold cross-validation
# for (i in 1:k) {
# 
#   qgams_model = qgam(CHF ~
#                        s(P,k=50,bs = "ad") +
#                        s(G,k=50,bs = "ad") +
#                        s(X,k=50,bs = "ad") +
#                        s(D,k = 50,bs = "ad") +
#                        s(L,k = 50,bs = "ad"),
#                      data =  base_treino[[i]],
#                      multicore = TRUE,
#                      ncores = 6,
#                      qu = 0.5)
# 
# 
#   qgam_pred_treino = predict(qgams_model, newdata = base_treino[[i]])
#   qgam_pred_teste = predict(qgams_model, newdata = base_teste[[i]])
# 
#   qgam_rmse_treino[i] = sqrt(mean((qgam_pred_treino - base_treino[[i]]$CHF)^2))
#   qgam_rmse_teste[i] = sqrt(mean((qgam_pred_teste - base_teste[[i]]$CHF)^2))
# 
#   base_treino[[i]]["predicoes_qgam_ad"] = qgam_pred_treino
#   base_teste[[i]]["predicoes_qgam_ad"] = qgam_pred_teste
# 
#   modelos_qgam[[i]] = qgams_model
# 
# }
# 
# qgam_pred_validacao = format(predict(qgams_model, newdata = base_validacao),scientific = FALSE)
# base_validacao["predicoes_qgam_ad"] = qgam_pred_validacao
# 
# 
# saveRDS(base_treino,"dados_treinamento_2.rds")
# saveRDS(base_teste,"dados_teste_2.rds")
# saveRDS(modelos_qgam,"modelos_qgam_50_ad.rds")
# write.csv(base_validacao,"dados_validacao_2.csv",row.names = FALSE)


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







# # modelo qgam q 0.5
# k <- 10
# 
# qgam_rmse_treino <- rep(0, k)
# qgam_rmse_teste = rep(0,k)
# modelos_qgam = list()
# 
# 
# # Perform k-fold cross-validation
# for (i in 1:k) {
# 
#   qgams_model = qgam(CHF ~
#                        s(P,k=50,bs = "tp") +
#                        s(G,k=50,bs = "tp") +
#                        s(X,k=50,bs = "tp") +
#                        s(D,k = 50,bs = "tp") +
#                        s(L,k = 50,bs = "tp"),
#                      data =  base_treino[[i]],
#                                           multicore = TRUE,
#                                           ncores = 6,
#                      qu = 0.5)
# 
# 
#   qgam_pred_treino = predict(qgams_model, newdata = base_treino[[i]])
#   qgam_pred_teste = predict(qgams_model, newdata = base_teste[[i]])
# 
#   qgam_rmse_treino[i] = sqrt(mean((qgam_pred_treino - base_treino[[i]]$CHF)^2))
#   qgam_rmse_teste[i] = sqrt(mean((qgam_pred_teste - base_teste[[i]]$CHF)^2))
# 
#   base_treino[[i]]["predicoes_qgam_tp"] = qgam_pred_treino
#   base_teste[[i]]["predicoes_qgam_tp"] = qgam_pred_teste
# 
#   modelos_qgam[[i]] = qgams_model
# 
# }

# qgam_pred_validacao = format(predict(qgams_model, newdata = base_validacao),scientific = FALSE)
# base_validacao["predicoes_qgam_tp"] = qgam_pred_validacao


# saveRDS(base_treino,"dados_treinamento_2.rds")
# saveRDS(base_teste,"dados_teste_2.rds")
# saveRDS(modelos_qgam,"modelos_qgam_50_tp.rds")
# write.csv(base_validacao,"dados_validacao_2.csv",row.names = FALSE)



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

base_modelagem = rbind(base_treino[[1]] %>% 
                         select(X,P,G,D,L,CHF),
                       base_teste[[1]]  %>% 
                         select(X,P,G,D,L,CHF),
                       base_validacao  %>% 
                         select(X,P,G,D,L,CHF))

# qgams_model = qgam(CHF ~
#                      s(P,k=20,bs = "cr") +
#                      s(G,k=20,bs = "cr") +
#                      s(X,k=20,bs = "cr") +
#                      s(D,k = 30,bs = "cr") +
#                      s(L,k = 30,bs = "cr") +
#                      ti(P,X,bs = "cr") +
#                      ti(P,G,bs = "cr") +
#                      ti(P,D,bs = "cr") +
#                      ti(P,L,bs = "cr") +
#                      ti(X,G,bs = "cr") +
#                      ti(X,D,bs = "cr") +
#                      ti(X,L,bs = "cr") +
#                      ti(G,D,bs = "cr") +
#                      ti(G,L,bs = "cr") +
#                      ti(D,L,bs = "cr"), 
#                    data =  base_modelagem,
#                    multicore = TRUE,
#                    ncores = 6,
#                    qu = 0.95)

#saveRDS(qgams_model,"modelos_qgam_95_inter_2.rds")

qgams_model = readRDS("modelos_qgam_95_inter_2.rds")

# check(qgams_model$calibr, 2)
# 
# summary(qgams_model)
# 
# check.qgam(qgams_model)
# 
# cqcheck(obj = qgams_model,v = c("L"))
# cqcheck(obj = qgams_model, v = c("P", "L"), nbin = c(5, 5))


preds = predict(qgams_model, 
                          newdata = base_modelagem,
                          se.fit = TRUE)

predicoes = preds$fit
erros_padrao = preds$se.fit
upper = predicoes + (2*erros_padrao)
lower = predicoes - (2*erros_padrao)


base_modelagem["predicoes_modelo_qgam"] = predicoes
base_modelagem["upper_modelo_qgam"] = upper
base_modelagem["lower_modelo_qgam"] = lower

base_modelagem = base_modelagem %>%
  arrange(CHF)

base_modelagem_2 = base_modelagem %>%
  filter(CHF > predicoes_modelo_qgam)

p1 = ggplot(base_modelagem %>% filter(CHF <= 10000)) +
  geom_point(aes(x = seq(1,nrow(base_modelagem %>% filter(CHF <= 10000))),y = CHF),size = 0.5) +
  geom_point(aes(x = seq(1,nrow(base_modelagem %>% filter(CHF <= 10000))), y = predicoes_modelo_qgam),size = 0.1,color = "red",alpha = 0.1) +
  #  geom_line(aes(x = seq(1,nrow(base_modelagem)), y = upper_modelo_qgam)) +
  #  geom_line(aes(x = seq(1,nrow(base_modelagem)), y = lower_modelo_qgam)) +
  #  geom_ribbon(aes(x = seq(1,nrow(base_modelagem)),ymin=lower_modelo_qgam,ymax=upper_modelo_qgam), fill="grey", alpha=0.3) +
  xlab("Observation") +
  ylab("CHF") +
  ggtitle("Predicted 0.95 quantile for CHF lower than 10,000") +
  theme(plot.title = element_text(hjust = 0.5,size = 10))#+
#  ylim(c(0,15000))

p1


p2 = ggplot(base_modelagem %>% filter(CHF > 10000) ) +
  geom_point(aes(x = seq(1,nrow(base_modelagem %>% filter(CHF > 10000))),y = CHF),size = 1) +
  geom_point(aes(x = seq(1,nrow(base_modelagem %>% filter(CHF > 10000) )), y = predicoes_modelo_qgam),size = 1,color = "red",alpha = 0.8) +
  #  geom_line(aes(x = seq(1,nrow(base_modelagem)), y = upper_modelo_qgam)) +
  #  geom_line(aes(x = seq(1,nrow(base_modelagem)), y = lower_modelo_qgam)) +
  #  geom_ribbon(aes(x = seq(1,nrow(base_modelagem)),ymin=lower_modelo_qgam,ymax=upper_modelo_qgam), fill="grey", alpha=0.3) +
  xlab("Observation") +
  ylab("CHF") +
  ggtitle("Predicted 0.95 quantile for CHF higher than 10,000") +
  theme(plot.title = element_text(hjust = 0.5,size = 10))

p2


p3 = ggplot(base_modelagem_2) +
  geom_point(aes(x = seq(1,nrow(base_modelagem_2)),y = CHF),size = 3) +
  geom_line(aes(x = seq(1,nrow(base_modelagem_2)), y = predicoes_modelo_qgam),color = "red",size = 1.2,alpha = 0.6) +
#  geom_line(aes(x = seq(1,nrow(base_modelagem_2)), y = upper_modelo_qgam)) +
#  geom_line(aes(x = seq(1,nrow(base_modelagem_2)), y = lower_modelo_qgam)) +
#  geom_ribbon(aes(x = seq(1,nrow(base_modelagem_2)),ymin=lower_modelo_qgam,ymax=upper_modelo_qgam), fill="grey", alpha=0.3) +
  xlab("Observation") +
  ylab("CHF") +
  ggtitle("Measured CHF values higher than the predicted quantile") +
  theme(plot.title = element_text(hjust = 0.5,size = 10)) 

grid_lok = grid.arrange(p1,p2,p3,
                        nrow = 3,
                        ncol = 1)


jpeg("../dados/qgam_95_preds.jpeg",width = 17,height = 10.51,units = "cm",res = 300)
grid_lok = grid.arrange(p1,p2,p3,
                        nrow = 3,
                        ncol = 1)
dev.off()


# # interpretacao e analise do modelo
# check1D(qgams_model, "P") + l_gridQCheck1D(qu = 0.95)
# check1D(qgams_model, "G") + l_gridQCheck1D(qu = 0.95)
# check1D(qgams_model, "X") + l_gridQCheck1D(qu = 0.95)
# check1D(qgams_model, "D") + l_gridQCheck1D(qu = 0.95)
# check1D(qgams_model, "L") + l_gridQCheck1D(qu = 0.95)
#  
#  
# cqcheck(obj = modelo_qgam, v = c("D_mm", "L_mm"),
#          X = dados_gro, 
#          y = dados_gro$CHF,
#          scatter = TRUE)
 


# # visao mais detalhada das funcoes de suavizacao
# 
b = getViz(qgams_model)
 
o <- plot( sm(b, 1) )
jpeg("../dados/p_qgam_95.jpeg",width = 17,height = 10.51,units = "cm",res = 300)
o + l_fitLine(colour = "red") + l_rug(mapping = aes(x=x, y=y), alpha = 0.8) +
  l_ciLine(mul = 5, colour = "blue", linetype = 2) +
  l_points(shape = 19, size = 1, alpha = 0.1) +
  theme_classic()
dev.off()



o <- plot( sm(b, 2) )
jpeg("../dados/g_qgam_95.jpeg",width = 17,height = 10.51,units = "cm",res = 300)
o + l_fitLine(colour = "red") + l_rug(mapping = aes(x=x, y=y), alpha = 0.8) +
 l_ciLine(mul = 5, colour = "blue", linetype = 2) +
 l_points(shape = 19, size = 1, alpha = 0.1) +
 theme_classic()
dev.off()

o <- plot( sm(b, 3) )
jpeg("../dados/x_qgam_95.jpeg",width = 17,height = 10.51,units = "cm",res = 300)
o + l_fitLine(colour = "red") + l_rug(mapping = aes(x=x, y=y), alpha = 0.8) +
 l_ciLine(mul = 5, colour = "blue", linetype = 2) +
 l_points(shape = 19, size = 1, alpha = 0.1) +
 theme_classic()
dev.off()

o <- plot( sm(b, 4) )
jpeg("../dados/d_qgam_95.jpeg",width = 17,height = 10.51,units = "cm",res = 300)
o + l_fitLine(colour = "red") + l_rug(mapping = aes(x=x, y=y), alpha = 0.8) +
 l_ciLine(mul = 5, colour = "blue", linetype = 2) +
 l_points(shape = 19, size = 1, alpha = 0.1) +
 theme_classic()
dev.off()

o <- plot( sm(b, 5) )
jpeg("../dados/l_qgam_95.jpeg",width = 17,height = 10.51,units = "cm",res = 300)
o + l_fitLine(colour = "red") + l_rug(mapping = aes(x=x, y=y), alpha = 0.8) +
 l_ciLine(mul = 5, colour = "blue", linetype = 2) +
 l_points(shape = 19, size = 1, alpha = 0.1) +
 theme_classic()
dev.off() 


jpeg("../dados/D_L_qgam_95.jpeg",width = 17,height = 10.51,units = "cm",res = 300)
plot(sm(b, 15)) + l_fitRaster() + l_fitContour() + l_points()
dev.off()



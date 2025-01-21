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
library(tidyr)



# calcula erros para base de treino e teste


base_treino = readRDS("../dados/dados_treinamento_2.rds")
base_teste = readRDS("../dados/dados_teste_2.rds")



k <- 10
me_treino = rep(0, k)
mae_treino = rep(0,k)
rmse_treino = rep(0,k)
me_teste = rep(0, k)
mae_teste = rep(0,k)
rmse_teste = rep(0,k)


for (i in 1:k){
  
  base_treino[[i]]$erro = (base_treino[[i]]$CHF - base_treino[[i]]$predicoes_gam_cr_int)/(base_treino[[i]]$CHF)
  base_treino[[i]]$erro_abs = abs(base_treino[[i]]$CHF - base_treino[[i]]$predicoes_gam_cr_int)/(base_treino[[i]]$CHF)
  base_treino[[i]]$erro_quad = ((base_treino[[i]]$CHF - base_treino[[i]]$predicoes_gam_cr_int)/(base_treino[[i]]$CHF))^2
  
  base_treino[[i]] = base_treino[[i]] %>%
    na.omit() 
  
  me_treino[i] = mean(base_treino[[i]]$erro)*100
  mae_treino[i] = mean(base_treino[[i]]$erro_abs)*100
  rmse_treino[i] = sqrt(mean(base_treino[[i]]$erro_abs))*100  
  
  
  base_teste[[i]]$erro = (base_teste[[i]]$CHF - base_teste[[i]]$predicoes_gam_cr_int)/(base_teste[[i]]$CHF)
  base_teste[[i]]$erro_abs = abs(base_teste[[i]]$CHF - base_teste[[i]]$predicoes_gam_cr_int)/(base_teste[[i]]$CHF)
  base_teste[[i]]$erro_quad = ((base_teste[[i]]$CHF - base_teste[[i]]$predicoes_gam_cr_int)/(base_teste[[i]]$CHF))^2
  
  base_teste[[i]] = base_teste[[i]] %>%
    na.omit() 
  
  me_teste[i] = mean(base_teste[[i]]$erro)*100
  mae_teste[i] = mean(base_teste[[i]]$erro_abs)*100
  rmse_teste[i] = sqrt(mean(base_teste[[i]]$erro_abs))*100  

}


round(mean(me_treino),2)
round(mean(mae_treino),2)
round(mean(rmse_treino),2)
round(mean(me_teste),2)
round(mean(mae_teste),2)
round(mean(rmse_teste),2)
which.min(rmse_teste)


# calcula predicoes com melhores modelos, e erros para base de validacao 

base_validacao = read.csv("dados_validacao_2.csv",sep = ",",dec = ".")

base_validacao = base_validacao[,!(names(base_validacao) %in% c("predicoes_lm","predicoes_glm_gauss_log",
          "predicoes_glm_gamma_log","preds_glm_gamma_log_inter",
          "preds_glm_gauss_log_inter","predicoes_gam_simples_ad_gamma_log",
          "predicoes_gam_simples_tp_gamma_log","predicoes_gam_simples_cr_gamma_log",
          "predicoes_gam_simples_cr_normal_log","predicoes_gam_simples_ad_normal_log",
          "predicoes_gam_simples_tp_normal_log","predicoes_gam_cr_int",
          "predicoes_qgam_cr","predicoes_qgam_ad","predicoes_qgam_tp"))]


model = readRDS("modelos_gam_cr_inter.rds")[[6]]
pred_validacao = exp(predict(model, newdata = base_validacao))
base_validacao["predicoes_modelo_cr_inter"] = pred_validacao

model = readRDS("modelos_qgam_50_tp.rds")[[6]]
pred_validacao = predict(model, newdata = base_validacao)
base_validacao["predicoes_modelo_qgam_tp"] = pred_validacao

base_validacao$erro = (base_validacao$CHF - base_validacao$predicoes_lookup_table_0312)/(base_validacao$CHF)
base_validacao$erro_abs = abs(base_validacao$CHF - base_validacao$predicoes_lookup_table_0312)/(base_validacao$CHF)
base_validacao$erro_quad = ((base_validacao$CHF - base_validacao$predicoes_lookup_table_0312)/(base_validacao$CHF))^2

base_validacao = base_validacao %>%
  na.omit()

me_validacao = mean(base_validacao$erro)*100
mae_validacao = mean(base_validacao$erro_abs)*100
rmse_validacao = sqrt(mean(base_validacao$erro_abs))*100


round(me_validacao,2)
round(mae_validacao,2)
round(rmse_validacao,2)


# gera graficos de real x predito de cada modelo

base_validacao = read.csv("dados_validacao_2.csv",sep = ",",dec = ".")

model = readRDS("modelos_gam_cr_inter.rds")[[6]]
pred_validacao = exp(predict(model, newdata = base_validacao))
base_validacao["predicoes_modelo_cr_inter"] = pred_validacao

model = readRDS("modelos_qgam_50_tp.rds")[[6]]
pred_validacao = predict(model, newdata = base_validacao)
base_validacao["predicoes_modelo_qgam_tp"] = pred_validacao

base_validacao = base_validacao %>%
  na.omit()

p1 = ggplot(base_validacao) +
  geom_point(aes(x = predicoes_lookup_table_0312,y = CHF)) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  labs(x = "Predicted Values",
       y = "CHF measured"
  ) +
  ggtitle("Lookup Table n=0.312") +
  theme(plot.title = element_text(hjust = 0.5,size = 5)) +
  xlim(c(0,20000)) +
  ylim(c(0,20000))  +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.text=element_text(size=5))


p2 = ggplot(base_validacao) +
  geom_point(aes(x = predicoes_mudawar_saida,y = CHF)) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  labs(x = "Predicted Values",
       y = "CHF measured"
  ) +
  ggtitle("Hall-Mudawar Outlet Conditions") +
  theme(plot.title = element_text(hjust = 0.5,size = 5)) +
  xlim(c(0,20000)) +
  ylim(c(0,20000))  +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.text=element_text(size=5))

p3 = ggplot(base_validacao) +
  geom_point(aes(x = predicoes_modelo_cr_inter,y = CHF)) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  labs(x = "Predicted Values",
       y = "CHF measured"
  ) +
  ggtitle("GAM 7") +
  theme(plot.title = element_text(hjust = 0.5,size = 5)) +
  xlim(c(0,20000)) +
  ylim(c(0,20000))  +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.text=element_text(size=5))

p4 = ggplot(base_validacao) +
  geom_point(aes(x = predicoes_modelo_qgam_tp,y = CHF)) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  labs(x = "Predicted Values",
       y = "CHF measured"
  ) +
  ggtitle("QGAM 2") +
  theme(plot.title = element_text(hjust = 0.5,size = 5)) +
  xlim(c(0,20000)) +
  ylim(c(0,20000))  +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.text=element_text(size=5))





grid_lok = grid.arrange(p1,p2,p3,p4,
                        nrow = 1,
                        ncol = 4)

jpeg("../dados/resultados_modelos.png",width = 17,height = 10.51,units = "cm",res = 300)
plot(grid_lok)
dev.off()



# grafico medida re


base_validacao = read.csv("dados_validacao_2.csv",sep = ",",dec = ".")

model = readRDS("modelos_gam_cr_inter.rds")[[6]]
pred_validacao = exp(predict(model, newdata = base_validacao))
base_validacao["predicoes_modelo_cr_inter"] = pred_validacao

model = readRDS("modelos_qgam_50_tp.rds")[[6]]
pred_validacao = predict(model, newdata = base_validacao)
base_validacao["predicoes_modelo_qgam_tp"] = pred_validacao

base_validacao = base_validacao %>%
  na.omit()

base_validacao["Lookup Table n=0.312"] = 100*((base_validacao$CHF - base_validacao$predicoes_lookup_table_0312)/base_validacao$CHF)
base_validacao["Hall-Mudawar Outlet Conditions"] = 100*((base_validacao$CHF - base_validacao$predicoes_mudawar_saida)/base_validacao$CHF)
base_validacao["GAM 7"] = 100*((base_validacao$CHF - base_validacao$predicoes_modelo_cr_inter)/base_validacao$CHF)
base_validacao["QGAM 2"] = 100*((base_validacao$CHF - base_validacao$predicoes_modelo_qgam_tp)/base_validacao$CHF)



base_validacao = base_validacao %>% 
  arrange(L)

base_validacao$id = seq(1,nrow(base_validacao))

lg_base_validacao = pivot_longer(base_validacao %>%
                                   select("id",
                                          "L",
                                          "Lookup Table n=0.312",
                                          "Hall-Mudawar Outlet Conditions",
                                          "GAM 7",
                                          "QGAM 2"),
                                 cols = c("Lookup Table n=0.312",
                                          "Hall-Mudawar Outlet Conditions",
                                          "GAM 7",
                                          "QGAM 2"),
                                 names_to = "Modelo",
                                 values_to = "RE")


p = ggplot(lg_base_validacao,aes(x = L,
                             y = RE,
                             color = Modelo)) +
  geom_point() +
  geom_hline(aes(yintercept = 0)) +
  geom_hline(aes(yintercept = 20),color = "red",linetype = "dashed") +
  geom_hline(aes(yintercept = -20),color = "red",linetype = "dashed") +
  xlab("L") +
  ylab("Relative Error") 

jpeg("../dados/re_l.jpeg",width = 17,height = 10.51,units = "cm",res = 300)
p
dev.off()



# grafico de observacao x predito com intervalo de confianca para o modelo gam e qgam

base_validacao = read.csv("dados_validacao_2.csv",sep = ",",dec = ".")

base_validacao = base_validacao %>%
  na.omit()


model = readRDS("modelos_gam_cr_inter.rds")[[6]]
preds_validacao = predict(model, newdata = base_validacao,se.fit = TRUE)
predicoes = preds_validacao$fit
erros_padrao = preds_validacao$se.fit
upper = predicoes + (2*erros_padrao)
lower = predicoes - (2*erros_padrao)
predicoes = exp(predicoes)
upper = exp(upper)
lower = exp(lower)

base_validacao["predicoes_modelo_cr_inter"] = predicoes
base_validacao["upper_modelo_cr_inter"] = upper
base_validacao["lower_modelo_cr_inter"] = lower


model = readRDS("modelos_qgam_50_tp.rds")[[6]]
preds_validacao = predict(model, newdata = base_validacao,se.fit = TRUE)
predicoes = preds_validacao$fit
erros_padrao = preds_validacao$se.fit
upper = predicoes + (2*erros_padrao)
lower = predicoes - (2*erros_padrao)


base_validacao["predicoes_modelo_qgam_tp"] = predicoes
base_validacao["upper_modelo_qgam_tp"] = upper
base_validacao["lower_modelo_qgam_tp"] = lower

base_validacao = base_validacao %>%
  arrange(CHF)


p1 = ggplot(base_validacao) +
  geom_point(aes(x = seq(1,nrow(base_validacao)),y = CHF)) +
  geom_line(aes(x = seq(1,nrow(base_validacao)), y = predicoes_modelo_qgam_tp),size = 0.8, color = "red", alpha = 0.5) +
  geom_line(aes(x = seq(1,nrow(base_validacao)), y = upper_modelo_qgam_tp)) +
  geom_line(aes(x = seq(1,nrow(base_validacao)), y = lower_modelo_qgam_tp)) +
  geom_ribbon(aes(x = seq(1,nrow(base_validacao)),ymin=lower_modelo_qgam_tp,ymax=upper_modelo_qgam_tp), fill="grey", alpha=0.3) +
  xlab("Observation") +
  ylab("Measured CHF") +
#  ggtitle("Predicted values behavior and their approximate prediction intervals (GAM 7)") +
  theme(plot.title = element_text(hjust = 0.5,size = 10)) 


jpeg("../dados/intervalo_confianca_gam.jpeg",width = 17,height = 10,units = "cm",res = 300)
plot(p1)
dev.off()

p2 = ggplot(base_validacao) +
  geom_point(aes(x = seq(1,nrow(base_validacao)),y = CHF)) +
  geom_line(aes(x = seq(1,nrow(base_validacao)), y = predicoes_modelo_cr_inter),size =0.8, color = "red", alpha = 0.5) +
  geom_line(aes(x = seq(1,nrow(base_validacao)), y = upper_modelo_cr_inter)) +
  geom_line(aes(x = seq(1,nrow(base_validacao)), y = lower_modelo_cr_inter)) +
  geom_ribbon(aes(x = seq(1,nrow(base_validacao)),ymin=lower_modelo_cr_inter,ymax=upper_modelo_cr_inter), fill="grey", alpha=0.4) + 
  xlab("Observation") +
  ylab("Measured CHF") +
  ggtitle("Predicted values behavior and their approximate prediction intervals (QGAM 2)") +
  theme(plot.title = element_text(hjust = 0.5,size = 10)) 


grid_lok = grid.arrange(p1,p2,
                          nrow = 2,
                          ncol = 1)


jpeg("../dados/intervalos_confianca_modelos.png",width = 17,height = 20,units = "cm",res = 300)
plot(grid_lok)
dev.off()

# interpretacao melhor modelo gam 

modelos_gam = readRDS("modelos_gam_cr_inter.rds")

modelo_best = modelos_gam[[6]]

library(mgcViz)  

modelo_best <- getViz(modelo_best)

o <- plot( sm(modelo_best, 5) )
o = o + l_fitLine(colour = "red") + l_rug(mapping = aes(x=x, y=y), alpha = 0.8) +
  l_ciLine(mul = 5, colour = "blue", linetype = 2) + 
  l_points(shape = 19, size = 1, alpha = 0.1) + theme_classic()

jpeg("../dados/L.jpeg",width = 17,height = 10.51,units = "cm",res = 300)
o
dev.off()


jpeg("../dados/D_L.jpeg",width = 17,height = 10.51,units = "cm",res = 300)
plot(sm(modelo_best, 15)) + l_fitRaster() + l_fitContour() + l_points()
dev.off()



check(modelo_best,
      a.qq = list(method = "simul1", 
                  a.cipoly = list(fill = "light blue")), 
      a.respoi = list(size = 0.5), 
      a.hist = list(bins = 10))









# resultado lookup 0.312 sem a ultima pasta
# round(mean(me_treino),2)
# [1] -0.62
# > round(mean(mae_treino),2)
# [1] 12.51
# > round(mean(rmse_treino),2)
# [1] 35.36
# > round(mean(me_teste),2)
# [1] -0.63
# > round(mean(mae_teste),2)
# [1] 9.98
# > round(mean(rmse_teste),2)
# [1] 31.26
# > which.min(rmse_teste)
# [1] 6

# resultados modelo gam cr inter
# > round(mean(me_treino),2)
# [1] -1
# > round(mean(mae_treino),2)
# [1] 7.39
# > round(mean(rmse_treino),2)
# [1] 27.19
# > round(mean(me_teste),2)
# [1] -1.58
# > round(mean(mae_teste),2)
# [1] 10.82
# > round(mean(rmse_teste),2)
# [1] 32.68
# > which.min(rmse_teste)
# [1] 6

# library(ggplot2)
# library(hrbrthemes)
# library(dplyr)
# library(tidyr)
# library(viridis)
# 
# a = base_treino[[6]]
# b = base_teste[[6]]
# a$Source = "Train Dataset"
# b$Source = "Test Dataset"
# 
# base = rbind(a,b)
# 
# plot_chf = ggplot(data=base, aes(x=CHF, group=Source, fill=Source)) +
#   geom_density(adjust=1.5, alpha=.4) +
#   theme_ipsum()   +
#   scale_x_continuous(labels = scales::comma)  +
#   theme(legend.position="none")  +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1))
# 
# plot_chf
# 
# library(fBasics)
# library(stats)
# 
# ks.test(a$CHF, b$CHF)
# 
# ggplot(base, aes(CHF, group = Source,fill = Source)) + stat_ecdf(geom = "point")

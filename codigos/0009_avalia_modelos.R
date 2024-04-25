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
    filter(dados_mudawar == 0) %>%
    na.omit() 
  
  me_treino[i] = mean(base_treino[[i]]$erro)*100
  mae_treino[i] = mean(base_treino[[i]]$erro_abs)*100
  rmse_treino[i] = sqrt(mean(base_treino[[i]]$erro_abs))*100  
  
  
  base_teste[[i]]$erro = (base_teste[[i]]$CHF - base_teste[[i]]$predicoes_gam_cr_int)/(base_teste[[i]]$CHF)
  base_teste[[i]]$erro_abs = abs(base_teste[[i]]$CHF - base_teste[[i]]$predicoes_gam_cr_int)/(base_teste[[i]]$CHF)
  base_teste[[i]]$erro_quad = ((base_teste[[i]]$CHF - base_teste[[i]]$predicoes_gam_cr_int)/(base_teste[[i]]$CHF))^2
  
  base_teste[[i]] = base_teste[[i]] %>%
    filter(dados_mudawar == 0) %>%
 #   filter(D != 120) %>%
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


resultados = bind_rows(base_teste)
resultados = resultados %>%
  filter(dados_mudawar==0)


p1 = ggplot(resultados) +
  geom_point(aes(x = predicoes_lookup_table_0312,y = CHF)) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  labs(x = "Valores Preditos",
       y = "FCC medido"
  ) +
  ggtitle("Lookup table n=0.312") +
  theme(plot.title = element_text(hjust = 0.5)) +
  xlim(c(0,60000)) +
  ylim(c(0,60000))

p2 = ggplot(resultados) +
  geom_point(aes(x = predicoes_mudawar_saida,y = CHF)) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  labs(x = "Valores Predito",
       y = "FCC medido"
  ) +
  ggtitle("Corr. Hall-Mudawar Saída") +
  theme(plot.title = element_text(hjust = 0.5)) +
  xlim(c(0,60000)) +
  ylim(c(0,60000))

p3 = ggplot(resultados) +
  geom_point(aes(x = predicoes_gam_cr_int,y = CHF)) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  labs(x = "Valores Predito",
       y = "FCC medido"
  ) +
  ggtitle("GAM 7") +
  theme(plot.title = element_text(hjust = 0.5)) +
  xlim(c(0,60000)) +
  ylim(c(0,60000))


grid_lok = grid.arrange(p1,p2,p3,
                        nrow = 1,
                        ncol = 3)

jpeg("../dados/resultados_modelos",width = 17,height = 10.51,units = "cm",res = 300)
grid_lok
dev.off()

modelos_gam = readRDS("modelos_gam_cr_inter.rds")

modelo_best = modelos_gam[[4]]

library(mgcViz)  

modelo_best <- getViz(modelo_best)

o <- plot( sm(modelo_best, 5) )
o + l_fitLine(colour = "red") + l_rug(mapping = aes(x=x, y=y), alpha = 0.8) +
  l_ciLine(mul = 5, colour = "blue", linetype = 2) + 
  l_points(shape = 19, size = 1, alpha = 0.1) + theme_classic()

plot(sm(modelo_best, 15)) + l_fitRaster() + l_fitContour() + l_points()

check(modelo_best,
      a.qq = list(method = "simul1", 
                  a.cipoly = list(fill = "light blue")), 
      a.respoi = list(size = 0.5), 
      a.hist = list(bins = 10))

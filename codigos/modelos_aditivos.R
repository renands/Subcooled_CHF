#########################################################
################# BIBLIOTECAS ###########################
#########################################################


library(mgcv)
library(dplyr)
library(janitor)
library(ggplot2)
library(ggpubr)
library(GGally)
library(qgam)
library(mgcViz)
library(tune)



#########################################################
################# DADOS GROENEVELD ######################
#########################################################


dados_gro = read.csv2("dados/dados_groeneveld.csv")
dados_gro = dados_gro %>%
  filter(X_chf < 0)



#########################################################
################# REGRESSAO LINEAR ######################
#########################################################


# regressao linear

lm_model = glm(log(CHF) ~ P_kpa + G + X_chf + D_mm + L_mm,
              data = dados_gro)

summary(lm_model)

plot(lm_model)


#########################################################
########### MLG COM OUTRAS DISTTRIBUICOES ###############
#########################################################



#########################################################
####################  GAMS    ###########################
#########################################################



# gams

gams_model_2 = gam(log(CHF) ~
                     s(P_kpa,k=50,bs = "cr") +
                     s(G,k=50,bs = "cr") +
                     X_chf #+
#                     s(D_mm,k = 30,bs = "cr") +
#                     s(L_mm,k = 30,bs = "cr")
  ,
                  data = dados_gro,
                  gamma = 1.5,
                  method = "REML"
)

plot(gams_model)

summary(gams_model)

gam.check(gams_model)

AIC(gams_model_2,gams_model)

BIC(gams_model_2,gams_model)




#########################################################
##################### QGAMS #############################
#########################################################


modelo_qgam = mgcViz::mqgamV(CHF ~
                               s(P_kpa,k=50,bs = "cr") +
                               s(G,k=50,bs = "cr") +
                               X_chf +
                               s(D_mm,k = 30,bs = "cr") +
                               s(L_mm,k = 30,bs = "cr"), 
                             data = dados_gro,
                             qu = c(0.05,0.5,0.95),
                             aQgam = list(multicore = TRUE,ncores = 3)
)


# interpretacao e analise do modelo
print(plot(modelo_qgam, allTerms = TRUE), pages = 1)
print(plot(modelo_qgam,select = c(1,2,3,4)), pages = 1)


check1D(modelo_qgam[[1]], "P_kpa") + l_gridQCheck1D(qu = 0.05)
check1D(modelo_qgam[[2]], "P_kpa") + l_gridQCheck1D(qu = 0.5)
check1D(modelo_qgam[[3]], "P_kpa") + l_gridQCheck1D(qu = 0.95)



check1D(modelo_qgam[[1]], "G") + l_gridQCheck1D(qu = 0.05)
check1D(modelo_qgam[[1]], "X_chf") + l_gridQCheck1D(qu = 0.05)
check1D(modelo_qgam[[1]], "D_mm") + l_gridQCheck1D(qu = 0.05)
check1D(modelo_qgam[[1]], "L_mm") + l_gridQCheck1D(qu = 0.05)

check1D(modelo_qgam[[2]], "G") + l_gridQCheck1D(qu = 0.5)
check1D(modelo_qgam[[2]], "X_chf") + l_gridQCheck1D(qu = 0.5)
check1D(modelo_qgam[[2]], "D_mm") + l_gridQCheck1D(qu = 0.5)
check1D(modelo_qgam[[2]], "L_mm") + l_gridQCheck1D(qu = 0.5)



cqcheck(obj = modelo_qgam[[1]], v = c("D_mm", "L_mm"),
        X = dados_gro, 
        y = dados_gro$CHF,
        scatter = TRUE)

cqcheck(obj = modelo_qgam[[2]], v = c("D_mm", "L_mm"),
        X = dados_gro, 
        y = dados_gro$CHF,
        scatter = TRUE)


cqcheck(obj = modelo_qgam[[3]], v = c("D_mm", "L_mm"),
        X = dados_gro, 
        y = dados_gro$CHF,
        scatter = TRUE)


check(modelo_qgam[[1]])
check(modelo_qgam[[2]])
check(modelo_qgam[[3]])


summary(modelo_qgam[[1]])
summary(modelo_qgam[[2]])
summary(modelo_qgam[[3]])


check(modelo_qgam[[1]]$calibr, 2)
check(modelo_qgam[[2]]$calibr, 2)
check(modelo_qgam[[3]]$calibr, 2)






# visao mais detalhada das funcoes de suavizacao

b = getViz(modelo_qgam[[2]])

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


unique(dados_gro$D_mm)



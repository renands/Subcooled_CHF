################################################################################
######### GERA BASE DE MODELAGEM PARA OS ESTUDOS  ##############################
################################################################################

setwd("../Subcooled_CHF/dados/")

library(dplyr)
library(ggplot2)

# dados groeneveld

dados_groenveld = read.csv("base_modelagem_groenveld.csv")

dados_groenveld = dados_groenveld %>%
  select(
    P_kpa,
    G,
    X_chf,
    D_mm,
    L_mm,
    CHF
  )

colnames(dados_groenveld) = c("P","G","X","D","L","CHF")

dados_groenveld["dados_mudawar"] = 0
dados_groenveld["fonte"] = "groeneveld"

# dados zhao

dados_zhao = read.csv("dados_modelagem_zhao.csv")

dados_zhao = dados_zhao %>%
  select(P_kpa,
         mass_flux_kg_m2_s,
         x_e_out,
         d_h_mm,
         length_mm,
         CHF
         )

colnames(dados_zhao) = c("P","G","X","D","L","CHF")

dados_zhao["dados_mudawar"] = 0
dados_zhao["fonte"] = "zhao"

# dados inasaka

dados_inasaka = read.csv("dados_modelagem_inasaka.csv")

dados_inasaka = dados_inasaka %>%
  select(
    P_kpa,
    G_kg_m2s,
    X_o,
    D_mm,
    L_mm,
    CHF
  )

colnames(dados_inasaka) = c("P","G","X","D","L","CHF")

dados_inasaka["dados_mudawar"] = 0
dados_inasaka["fonte"] = "inasaka"


# dados mudawar

dados_mudawar = read.csv("dados_modelagem_mudawar.csv")

dados_mudawar = dados_mudawar %>%
  select(
    P_kpa,
    G,
    X_o,
    D_mm,
    L_mm,
    CHF
  )

colnames(dados_mudawar) = c("P","G","X","D","L","CHF")

dados_mudawar["dados_mudawar"] = 1
dados_mudawar["fonte"] = "mudawar"

# junta as bases de dados

dados_modelagem = rbind(dados_groenveld,
                        dados_inasaka,
                        dados_mudawar,
                        dados_zhao)

# reordena a base aleatoriamente
set.seed(123)
dados_modelagem = sample(dados_modelagem,replace = FALSE)

write.csv(dados_modelagem,"dados_modelagem_2.csv",row.names = FALSE)


